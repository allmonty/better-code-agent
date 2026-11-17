#!/usr/bin/env bash
# The last commit changes parse_amount from dollars to cents and updates its
# own test. invoice.py (not in the diff) sums the amounts and format.py
# (not in the diff either) renders them as dollars, so totals are 100x off.
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh"
cat > textutils/money.py <<'PY'
from decimal import Decimal


def parse_amount(text):
    """Parse a price like "12.50" into dollars."""
    return Decimal(text.strip().lstrip("$"))
PY
cat > textutils/format.py <<'PY'
def format_total(dollars):
    return f"Total: ${dollars:,.2f}"
PY
cat > textutils/invoice.py <<'PY'
from textutils.format import format_total
from textutils.money import parse_amount


def invoice_footer(line_prices):
    total = sum(parse_amount(p) for p in line_prices)
    return format_total(total)
PY
cat > tests/test_money.py <<'PY'
import unittest
from decimal import Decimal

from textutils.money import parse_amount


class ParseAmountTest(unittest.TestCase):
    def test_parses_dollars(self):
        self.assertEqual(parse_amount("$12.50"), Decimal("12.50"))
PY
git add -A && git commit -q -m "Add invoice footer"
cat > textutils/money.py <<'PY'
from decimal import Decimal


def parse_amount(text):
    """Parse a price like "12.50" into integer cents, to avoid float drift."""
    return int(Decimal(text.strip().lstrip("$")) * 100)
PY
cat > tests/test_money.py <<'PY'
import unittest

from textutils.money import parse_amount


class ParseAmountTest(unittest.TestCase):
    def test_parses_to_cents(self):
        self.assertEqual(parse_amount("$12.50"), 1250)
PY
git add -A && git commit -q -m "Store amounts as integer cents"
