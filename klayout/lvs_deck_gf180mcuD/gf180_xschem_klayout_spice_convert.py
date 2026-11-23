#!/usr/bin/env python3
################################################################################################
# Copyright 2025 GlobalFoundries PDK Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################################
"""
gf180_xschem_klayout_spice_convert.py

Adapt SPICE textfiles from xschem export to klayout by applying ordered transformation rules.

Based on https://github.com/Scafir/pdk-spice-convert, relicensed to Apache 2 license with
permission from the author.

This is a stopgap measure. It should be replaced by a propercustom spice reader implementation
for klayout.

Usage see: python gf180_xschem_klayout_spice_convert.py  --help
"""

from __future__ import annotations
import re
import os
import sys
import argparse
from typing import List, Dict, Callable, Optional


class Rule:
    """
    Base class for transformation rules.
    Subclass and implement `apply` to transform a single line.
    """
    name = "base"

    def apply(self, line: str, meta: Dict) -> str:
        """
        Transform a single line. Return transformed line (or same line if unchanged).
        `meta` is a dictionary that may hold extra state (e.g. filename, line number).
        """
        raise NotImplementedError


class ContinuationFlattenRule(Rule):
    """
    Flatten SPICE continuation lines:
      - A line beginning (after whitespace) with '+' is a continuation of the previous
        non-continuation line.
      - The '+' and a single optional following space are removed and the remainder
        is appended to the previous logical line.
      - The rule operates on the whole document (list of lines) and returns a new list
        of lines (each ending with its newline, except possibly the last).
    """

    name = "continuation_flatten"

    _cont_rx = re.compile(r"^(\s*)\+\s?(.*)$")  # captures indent and continuation payload

    def apply_document(self, lines: List[str]) -> List[str]:
        """
        lines: list of strings as read from file (preserving newline endings)
        returns: new list of strings with continuations flattened
        """
        out_lines: List[str] = []
        buffer: str | None = None  # holds the current logical line being built (no extra newline yet)

        for line in lines:
            m = self._cont_rx.match(line)
            if m:
                # This line is a continuation
                payload = m.group(2)

                if buffer is None:
                    # continuation with no starter: treat as a normal line (safer)
                    # keep original line unchanged
                    out_lines.append(line)
                    continue

                # Append payload to buffer (strip trailing newline from buffer first)
                # We append payload exactly as-is (do not re-introduce the '+')
                if buffer.endswith("\n"):
                    buffer = buffer[:-1]  # drop trailing newline to append continuation
                buffer += " " + payload
                # Do not append to out_lines yet; there may be more continuations
            else:
                # This line is a normal starter line.
                # If we have a buffered logical line, flush it to out_lines first.
                if buffer is not None:
                    # ensure buffer ends with newline when flushed
                    if not buffer.endswith("\n"):
                        buffer = buffer + "\n"
                    out_lines.append(buffer)
                # Start a new buffer with the current line (preserve it as-is)
                buffer = line

        # flush last buffer
        if buffer is not None:
            if not buffer.endswith("\n"):
                buffer = buffer + "\n"
            out_lines.append(buffer)

        return out_lines


class EnvVarSubstitutionRule(Rule):
    """
    Replace occurrences of $::VAR with the value of environment variable VAR.

    - Matches patterns like:
        $::MY_VAR
        $::MY_VAR/and/a/path   -> only the $::MY_VAR part is replaced
    - Does NOT match escaped \\$::VAR (one slash plus $) keeps the backslash + token
    - If the env var is missing, emits a warning and leaves $::VAR as-is
    """

    name = "env_var_substitution_v2"

    # Explanation of the regex:
    # (?<!\\)        - don't match if preceded by a backslash (allow escaping)
    # \$::           - literal marker
    # ([A-Za-z_][A-Za-z0-9_]*) - capture the variable name (letters, digits, underscore)
    # (?=$|[^A-Za-z0-9_]) - ensure the next char is either end-of-string or a non-identifier character
    # Match one or more "word" characters (letters, digits, underscore)
    _pattern = re.compile(r"(?<!\\)\$::(\w+)(?=$|[^A-Za-z0-9_])")

    def apply(self, line: str, meta: dict) -> str:
        # Fast path
        if "$::" not in line:
            return line

        lineno = meta.get("lineno", "?")

        def repl(m: str | re.Pattern) -> str:
            varname = m.group(1)
            value = os.environ.get(varname)
            if value is None:
                # Warn and leave the original token untouched
                raise ValueError(f"Line {lineno}: environment variable '{varname}' not found\n")

            value = "\"" + value + "\""

            return value

        return self._pattern.sub(repl, line)


class IncludeRecursiveDirectiveRule(Rule):
    """
    Handle ".include <path> ..." directives, flattening nested includes too.

    Adds:
      - Recursively expands .include directives found inside included files.
      - Detects include cycles to prevent infinite recursion.
    """
    name = "include_directive"
    _regex = re.compile(r"^(\s*)\.include\b\s+(\S+)", flags=re.IGNORECASE)

    def apply(self, line: str, meta: Dict) -> str:
        # Preserve original behavior: only process if this line is an include directive
        if ".include" not in line.lower():
            return line

        m = self._regex.match(line)
        if not m:
            return line

        lineno = meta.get("lineno", "?")

        # Track include stack/visited for cycle detection across recursion
        include_stack = meta.setdefault("_include_stack", [])  # list of paths in current chain

        raw_path_token = m.group(2)
        path = self._strip_quotes(raw_path_token)

        if not os.path.isabs(path):
            raise ValueError(
                f"Line {lineno}: .include path '{path}' is not absolute; refusing to include relative path."
            )

        # Cycle detection (A -> B -> A)
        if path in include_stack:
            chain = " -> ".join(include_stack + [path])
            raise ValueError(f"Line {lineno}: include cycle detected: {chain}")

        # Read file content
        try:
            with open(path, "r", encoding="utf-8") as fh:
                content = fh.read()
        except Exception as e:
            raise IOError(f"Line {lineno}: failed to read include file '{path}': {e}") from e

        # Recursively expand includes within the included file
        include_stack.append(path)
        try:
            flattened = self._expand_includes_in_text(
                content,
                meta,
                parent_path=path,
            )
        finally:
            include_stack.pop()

        if not flattened.endswith("\n"):
            flattened += "\n"
        return flattened

    def _expand_includes_in_text(self, text: str, meta: Dict, parent_path: Optional[str] = None) -> str:
        """
        Walk the included text line-by-line and apply this rule recursively so nested
        .include directives are expanded.
        """
        out_lines = []
        # Use splitlines(True) to preserve newlines exactly
        for i, ln in enumerate(text.splitlines(True), start=1):
            # Provide a useful "lineno" context for errors inside included files
            child_meta = dict(meta)
            if parent_path:
                child_meta["lineno"] = f"{parent_path}:{i}"
            else:
                child_meta["lineno"] = i

            out_lines.append(self.apply(ln, child_meta))
        return "".join(out_lines)

    @staticmethod
    def _strip_quotes(token: str) -> str:
        if (token.startswith('"') and token.endswith('"')) or (token.startswith("'") and token.endswith("'")):
            return token[1:-1]
        return token


class GenericDeviceParamRenameRule(Rule):
    """
    Generic rule to rename parameters for lines that start with a specific device character.

    Parameters
    ----------
    device_char : str
        Single character identifying the device type (e.g. "R", "M", "Q").
        Matching is case-insensitive and compares to the first non-whitespace character.
    param_map : Dict[str, str]
        Mapping from source parameter name -> destination parameter name.
        Matching is case-insensitive and uses word boundaries so partial names won't be replaced.
    flags : int, optional
        Regex flags to use when matching parameter assignments (default re.IGNORECASE).
    """
    name = "generic_device_param_rename"

    def __init__(self, device_char: str, param_map: Dict[str, str], flags: int = re.IGNORECASE):
        if not device_char or len(device_char.strip()) != 1:
            raise ValueError("device_char must be a single non-empty character.")
        self.device_char = device_char.upper()
        self.param_map = dict(param_map)  # copy to avoid mutation surprises
        self.flags = flags
        # compile regexes for each source param for performance
        self._regexes = {
            src: re.compile(rf"\b({re.escape(src)})\b(\s*=\s*)([^ \t\n]+)", flags=self.flags)
            for src in self.param_map.keys()
        }

    def apply(self, line: str, meta: dict) -> str:
        # leave blank lines as-is
        if not line.strip():
            return line

        # get leading whitespace and remainder
        leading_ws_match = re.match(r"^(\s*)", line)
        leading_ws = leading_ws_match.group(1) if leading_ws_match else ""
        rest = line[len(leading_ws):]

        if not rest:
            return line

        # check the first non-whitespace character matches device_char
        if rest[0].upper() != self.device_char:
            return line

        new_rest = rest
        # apply every parameter mapping (replace all occurrences)
        for src, dst in self.param_map.items():
            rx = self._regexes.get(src)
            if rx is None:
                # safety: compile on the fly if missing
                rx = re.compile(rf"\b({re.escape(src)})\b(\s*=\s*)([^ \t\n]+)", flags=self.flags)
                self._regexes[src] = rx

            def repl(match: re.Match) -> str:
                eq_and_spacing = match.group(2)
                value = match.group(3)
                return f"{dst}{eq_and_spacing}{value}"

            new_rest = rx.sub(repl, new_rest)

        return f"{leading_ws}{new_rest}"


class SpicePrefixRemovalRule(Rule):
    """
    Rule 1: If a line starts with X (after any leading whitespace), remove that X.
    Preserves indentation around the removed X.
    """
    name = "spiceprefix_removal"

    def apply(self, line: str, meta: Dict) -> str:
        # Leave blank lines and comment lines untouched
        if not line.strip():
            return line

        # Find leading whitespace
        leading_ws_match = re.match(r"^(\s*)", line)
        leading_ws = leading_ws_match.group(1) if leading_ws_match else ""
        rest = line[len(leading_ws):]

        if rest.startswith("X"):
            # Remove only the first 'X' character
            new_rest = rest[1:]
            return f"{leading_ws}{new_rest}"
        else:
            return line


class SpicePrefixSuperflousRemovalRule(Rule):
    """
    Remove leading SPICE 'X' prefix only if it is NOT immediately followed by a digit.
    Examples:
        "  Xfoo bar"  -> "  foo bar"
        "  X_1 bar"   -> "  _1 bar"
        "  X42 foo"   -> unchanged  (because 'X' is followed by a digit)
        "  Ysomething" -> unchanged
    """

    name = "spiceprefix_conditional_removal"

    def apply(self, line: str, meta: Dict) -> str:
        # Leave blank lines or pure comment lines untouched
        if not line.strip():
            return line

        # Leading indentation
        m = re.match(r"^(\s*)", line)
        leading_ws = m.group(1) if m else ""
        rest = line[len(leading_ws):]

        # Only act if the rest starts with 'X'
        if not rest.startswith("X"):
            return line

        # If the next character exists and is a digit, do nothing
        if len(rest) > 1 and rest[1].isdigit():
            return line

        # Otherwise remove the X
        return f"{leading_ws}{rest[1:]}"


class ConditionalLeadingXReplaceRule(Rule):
    """
    Replace a leading 'X' (first non-whitespace char) with a provided replacement string
    when a given substring is found somewhere in the line.

    Parameters
    ----------
    match_substring : str
        The substring to look for in the line. If found (according to case sensitivity),
        the rule will perform the leading-'X' replacement.
    replacement : str
        The string that will replace the leading 'X'. If the line's first non-whitespace
        character isn't 'X', the line is left unchanged.
    case_sensitive : bool
        Whether the substring match should be case-sensitive. Default: False.

    Behavior
    --------
    - If the first non-whitespace character is 'X' and `match_substring` appears in the line,
      the leading 'X' is replaced by `replacement` (preserving leading whitespace).
    - Everything after the replaced 'X' is left intact.
    - If `match_substring` is not found, the line is returned unchanged.
    """
    name = "conditional_leading_x_replace"

    def __init__(self, match_substring: str, replacement: str, case_sensitive: bool = False):
        if not match_substring:
            raise ValueError("match_substring must be a non-empty string")
        self.match_substring = match_substring
        self.replacement = replacement
        self.case_sensitive = case_sensitive
        # precompile a pattern for fast presence checking (we'll use search, not full match)
        flags = 0 if case_sensitive else re.IGNORECASE
        # Escape substring so it is treated literally
        self._match_rx = re.compile(re.escape(match_substring), flags=flags)

    def apply(self, line: str, meta: Dict) -> str:
        # fast path
        if not line or not line.strip():
            return line

        # find leading whitespace and remainder
        m = re.match(r"^(\s*)(.*)$", line, flags=re.DOTALL)
        leading_ws = m.group(1)
        rest = m.group(2)

        if not rest:
            return line

        # only act if the first non-whitespace char is 'X'
        if not rest.startswith("X"):
            return line

        # check whether the match_substring appears in the line according to case sensitivity
        if not self._match_rx.search(line):
            return line  # substring not present -> no replacement

        # perform the replacement of the first 'X' only
        new_rest = self.replacement + rest[1:]
        return f"{leading_ws}{new_rest}"


class Pipeline:
    """
    Simple rule-by-rule pipeline
    """

    def __init__(self, rules_line: List[Rule], rules_document: List[Rule]) -> None:
        self.rules_line = rules_line
        self.rules_document = rules_document

    def process_stream(self, in_stream, out_stream, verbose: bool = False):
        # Read all lines as a simple list (preserve endings)
        lines = in_stream.readlines()

        for rule in self.rules_document:
            lines = rule.apply_document(lines)
            if verbose:
                sys.stderr.write(f"[{rule.name}] applied document-level transform; {len(lines)} lines now\n")

        for rule in self.rules_line:
            new_lines = []
            for lineno, line in enumerate(lines, start=1):
                meta = {"lineno": lineno, "rule": rule.name}
                new_line = rule.apply(line, meta)

                if verbose and new_line != line:
                    before = line.rstrip("\n")
                    after = new_line.rstrip("\n")
                    sys.stderr.write(f"[{rule.name}] line {lineno}: '{before}' -> '{after}'\n")

                # Allow rules to inject multiple lines (e.g. from .include)
                if "\n" in new_line:
                    parts = new_line.splitlines(keepends=True)
                    new_lines.extend(parts)
                else:
                    new_lines.append(new_line)

            # Update for the next rule
            lines = new_lines

        # Write final output
        for line in lines:
            out_stream.write(line)


def build_default_pipeline() -> Pipeline:
    """
    Construct the default pipeline in the requested order:
      1) Spice prefix removal
      2) R-parameter renaming
    """
    rules_document: List[Rule] = [
        ContinuationFlattenRule(),
    ]
    rules_line: List[Rule] = [
        EnvVarSubstitutionRule(),
        IncludeRecursiveDirectiveRule(),
        ConditionalLeadingXReplaceRule("cap_nmos", "C"),
        ConditionalLeadingXReplaceRule("ppolyf_u", "R"),
        ConditionalLeadingXReplaceRule("nfet", "M"),
        ConditionalLeadingXReplaceRule("pfet", "M"),
        SpicePrefixSuperflousRemovalRule(),
        GenericDeviceParamRenameRule("Q", {"m": "NE"}),
        GenericDeviceParamRenameRule("R", {"r_width": "W", "r_length": "L"}),
        GenericDeviceParamRenameRule("D", {"area": "A", "pj": "P"}),
        GenericDeviceParamRenameRule("C", {"c_width": "W", "c_length": "L"}),
    ]
    return Pipeline(rules_line, rules_document)


def parse_args():
    p = argparse.ArgumentParser(description="Adapt a SPICE textfile by applying transformation rules.")
    p.add_argument("input", nargs="?", default="-", help="Input file path (default: stdin)")
    p.add_argument("-o", "--output", default="-", help="Output file path (default: stdout)")
    p.add_argument("--dry-run", action="store_true", help="Run transformations and print changes to stderr but do not write output (writes to stdout anyway).")
    p.add_argument("--verbose", action="store_true", help="Verbose. Print transformed lines to stderr.")
    return p.parse_args()


def main():
    args = parse_args()
    pipeline = build_default_pipeline()

    # Input stream
    if args.input == "-":
        in_stream = sys.stdin
    else:
        in_stream = open(args.input, "r", encoding="utf-8")

    # Output stream
    if args.output == "-":
        out_stream = sys.stdout
    else:
        out_stream = open(args.output, "w", encoding="utf-8")

    try:
        pipeline.process_stream(in_stream, out_stream, verbose=args.verbose)
    finally:
        if in_stream is not sys.stdin:
            in_stream.close()
        if out_stream is not sys.stdout:
            out_stream.close()


if __name__ == "__main__":
    main()
