#!/usr/bin/env bash
# No templates and no plan: a three-part feature request, end to end.
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh" --bare
