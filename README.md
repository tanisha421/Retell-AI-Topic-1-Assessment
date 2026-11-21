# Tayana Academy – Retell AI Lead Generation & Admission Counselling Agent

An implementation starter for the 12-page Tayana Academy practical assessment specification.

## What is included
- `Retell_Agent_Config/`: production-oriented system prompt, voice settings checklist, dynamic-variable example, and custom-tool JSON schemas.
- `Knowledge_Base/`: approved six-course catalogue and safe FAQ/escalation rules.
- `Backend_Service/`: Node.js/Express API, deterministic lead scoring, Retell custom-tool handlers, signed webhook verification, idempotent call ingestion, PostgreSQL DDL, and unit tests.
- `Test_Evidence_Pack/`: all 30 required scenarios with expected assertions and an evidence log template.
- `docs/`: architecture and live demonstration guide.

## Important implementation boundary
This repository prepares the code and configuration artifacts. It cannot create or configure a Retell account, provision a phone number, select an actual voice, configure a real transfer destination, make live calls, or produce genuine call recordings. Complete the Retell console steps in `Retell_Agent_Config/RETELL_SETUP.md`, then replace every `CHANGE_ME` value using credentials and contact details supplied by Tayana Academy. Do not use real prospective-student data for testing; use synthetic leads and obtain consent before any real outreach.

## Requirements
- Node.js 20+
- PostgreSQL 14+
- Retell API account and approved outbound caller ID (for live integration)

## Local setup
```bash
cd Backend_Service
cp .env.example .env
npm install
# Create a PostgreSQL database, then apply:
psql "$DATABASE_URL" -f db/schema.sql
npm test
npm start
```

Health check:
```bash
curl http://localhost:3000/health
```

## Environment variables
See `Backend_Service/.env.example`. Secrets belong only in `.env` or a secret manager. Never commit `.env`.

## API endpoints
- `GET /health`
- `GET /api/leads/:id`
- `POST /api/retell/outbound-call`
- `POST /api/retell/tools/:toolName`
- `POST /api/retell/webhook`
- `POST /api/callbacks`
- `POST /api/leads/:id/opt-out`

Outbound dispatch enforces E.164 phone validation, suppression checks, and 10:00–19:00 Asia/Kolkata calling hours. Campaign concurrency and retry scheduling are represented by a guarded pilot dispatcher; connect it to a durable queue before production use.

## Retell custom tools
Create six Retell custom functions using the schemas in `Retell_Agent_Config/custom_tools.json`. Set each tool URL to:
`https://YOUR_PUBLIC_HOST/api/retell/tools/TOOL_NAME`
The backend accepts `{ "args": { ... } }` and also tolerates direct argument objects.

## Webhooks
Configure Retell's call event webhook to:
`https://YOUR_PUBLIC_HOST/api/retell/webhook`
Set `RETELL_WEBHOOK_SECRET`. Requests must include a valid `x-retell-signature` HMAC-SHA256 signature over the raw request body. Confirm the exact signature format in the Retell account documentation before enabling production traffic; this implementation expects a hex digest.

## Local webhook tunneling
Use ngrok or Cloudflare Tunnel to expose port 3000. Keep the tunnel URL private and configure it only in the Retell console. Do not expose credentials in screenshots or recordings.

## Lead scoring
The scoring engine implements the assessment matrix:
- Approved course interest: +20
- Enrollment within 7 days: +25
- Enrollment within 30 days: +15 (mutually exclusive with 7-day urgency)
- Requests admission/enrollment details: +15
- Accepts counsellor transfer or callback: +15
- Meets target prerequisites: +10
Maximum: 100. HOT >=70; WARM 45–69; COLD <45. DNC and WRONG_NUMBER are overriding dispositions, not scored leads. CALLBACK_REQUIRED is a routing condition and must not be misclassified as COLD.

## Production checklist
- Confirm approved course documents and current commercial facts with Tayana Academy.
- Supply real counsellor transfer number and approved outbound caller ID.
- Verify Retell webhook signature format and test with genuine signed events.
- Add authentication/authorization to internal endpoints and rate limiting at the gateway.
- Use a managed PostgreSQL instance, encrypted backups, retention policy, and access controls.
- Add a durable queue for retries/callback reminders and enforce one concurrent pilot call.
- Run the complete 30-case matrix and attach actual call IDs, recordings, webhook payloads, and screenshots.
- Review applicable telecom, privacy, consent, and DND requirements with the organization before live outreach.

## Cost-per-minute analysis
No vendor prices are hardcoded because telephony, voice, LLM, and Retell rates vary by plan, region, and usage. Calculate:
`total cost per minute = Retell platform + telephony + speech/voice + LLM + infrastructure`
Record the current vendor rates, currency, billing increments, and call mix in the final submission.
