---
type: llm
weight: 2
---

PASS if the response says that invoice totals are now wrong because `invoice_footer` in textutils/invoice.py sums cents and `format_total` in textutils/format.py still formats the value as dollars (totals 100 times too large), and treats this as something to fix before merging.
FAIL if it doesn't identify the cents-versus-dollars mismatch in the invoice/format path, or approves the commit as ready to merge.
