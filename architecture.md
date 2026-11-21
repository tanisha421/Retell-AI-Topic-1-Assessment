# Architecture

1. Lead source / CRM stores candidate data and consent status.
2. Outbound dispatcher checks eligibility, DND suppression, Indian E.164 phone format, allowed calling hours, and pilot concurrency policy.
3. Retell calls the candidate using dynamic variables from trusted backend data.
4. Agent verifies identity and permission, performs discovery, and invokes custom tools.
5. Backend tools read/update lead records, calculate deterministic disposition, schedule callbacks, request transfer routing, or persist DND suppression.
6. Retell emits lifecycle and post-call events to a webhook. HMAC verification and unique `call_id` prevent forged or duplicate event ingestion.
7. PostgreSQL stores lead, callback, suppression, and call-log records.

## State sequence
Call connected → identity verification → permission check → discovery → course interest/FAQ → qualification → HOT transfer / WARM callback / COLD low-priority follow-up → polite wrap-up → post-call extraction and CRM sync.

Wrong person, DND, and busy/callback branches exit the main discovery path immediately.
