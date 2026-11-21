#!/usr/bin/env bash
# Bare project with a Makefile check target requiring public functions in text.py
# to be re-exported from textutils/__init__.py (not mentioned in the prompt).
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh" --bare
cat > textutils/__init__.py <<'PY'
from textutils.text import title_case
PY
cat > Makefile <<'MK'
check:
	python3 -m unittest discover -s tests -t .
	python3 -c 'import ast, textutils, sys; names = [n.name for n in ast.parse(open("textutils/text.py").read()).body if isinstance(n, ast.FunctionDef) and not n.name.startswith("_")]; missing = [n for n in names if not hasattr(textutils, n)]; sys.exit("textutils/__init__.py missing exports: " + ", ".join(missing) if missing else 0)'
MK
git add -A && git commit -q -m "Export title_case in __init__ and add Makefile check"
