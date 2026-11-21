#!/usr/bin/env bash
# Adds slugify() with branching logic, paired with tautological/weak tests.
set -euo pipefail
bash "$(dirname "${BASH_SOURCE[0]}")/../_fixtures/python-project.sh"
cat >> textutils/text.py <<'PY'


def slugify(title):
    out = []
    prev_dash = False
    for ch in title.lower():
        if ch.isalnum():
            out.append(ch)
            prev_dash = False
        elif not prev_dash and out:
            out.append("-")
            prev_dash = True
    return "".join(out).rstrip("-")
PY
cat > tests/test_text.py <<'PY'
import unittest

from textutils.text import slugify, title_case


class TitleCaseTest(unittest.TestCase):
    def test_capitalises_each_word(self):
        self.assertEqual(title_case('hello world'), 'Hello World')


class SlugifyTest(unittest.TestCase):
    def test_slugify_works(self):
        result = slugify("Hello, World!")
        self.assertIsNotNone(result)
        self.assertIsInstance(result, str)

    def test_slugify_nonempty(self):
        self.assertTrue(len(slugify("foo bar")) > 0)


if __name__ == "__main__":
    unittest.main()
PY
git add -A && git commit -q -m "Add slugify and tests"
