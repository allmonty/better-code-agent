#!/usr/bin/env bash
# Single quality gate for this repo; the Stop hook and humans both run this.
exec "$(dirname "$0")/../tests/run.sh"
