# Redaction Map (DRAFT — pending Approver sign-off) — VDI-2025-0503
Sensitive-value rule: redacted values are referenced by location only; never echoed here or in any deliverable.

| # | File | Location of span | Category | Reason |
|---|---|---|---|---|
| R1 | E018 | Body, "SSN:" field | SSN | PII — Social Security number has no substantive value to claims |
| R2 | E018 | Body, "Home address:" field | Home address | PII — residence not material; matter concerns work devices |
| R3 | E018 | Body, "Personal cell:" field | Personal phone | PII — personal contact not material |
| R4 | E018 | Body, "Emergency contact" line (phone field) | Personal phone (spouse) | PII — third-party personal number; retain name reference only if needed |
| R5 | D006 | Header block, "Home Address" field | Home address | PII — as R2 |
| R6 | D006 | Header block, "Personal Phone" field | Personal phone | PII — as R3 |
| R7 | D006 | Header block, "Emergency Contact" phone field | Personal phone (spouse) | PII — as R4 |
| R8 | D004 (privilege log entry, not produced doc) | Exposure-range sentence | Damages estimate | Settlement/exposure valuation — withheld value even from internal summary tables to prevent privilege leakage |

Applied-at-redaction markers: spans above replaced with [REDACTED — <category>] in the redacted-document set (produced only after Approver approval).
