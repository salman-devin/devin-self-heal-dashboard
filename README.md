# Devin Self-Heal · dashboard

Observability interface for the self-healing maintenance automation running on
[`salman-devin/superset`](https://github.com/salman-devin/superset)
([implementation PR](https://github.com/salman-devin/superset/pull/10)).

**Live:** https://salman-devin.github.io/devin-self-heal-dashboard/

## What it shows

| View | Contents |
| --- | --- |
| Task feed | Every maintenance issue, its severity, whether an agent is working on it, the Devin session link, the pull request it produced, and the effort it consumed |
| Operations & SLA | Service level objectives and attainment, agent runtime metrics, CI success rate and latency percentiles, engineering effectiveness metrics, and recent workflow failures |
| Architecture | The dual-trigger pipeline — scheduled discovery and label-driven remediation — plus the guardrails and a glossary of every term used |
| Config & API | Repository selector, optional GitHub token, and the raw derived metrics as JSON |

## Data

Everything is read live from the GitHub REST API in the browser on load and
every 60 seconds:

- `GET /repos/{repo}/issues` — the maintenance backlog, labels and severities
- `GET /repos/{repo}/issues/{n}/comments` — the automation's status comments,
  which carry the Devin session URL, outcome, effort and pull request link
- `GET /repos/{repo}/actions/runs` — run counts, conclusions and durations

If the API is unreachable (offline, or the unauthenticated 60 requests/hour
budget is exhausted) it falls back to a small embedded snapshot and says so in
the header.

The Devin API is never called from the browser. The API key exists only inside
the GitHub Actions job that starts sessions.

## Any repository

The dashboard is repository-agnostic. Point it anywhere:

```
https://salman-devin.github.io/devin-self-heal-dashboard/?repo=owner/name
```

or set it in the **Config & API** tab. A read-only GitHub token can be pasted
there to raise the rate limit to 5,000 requests/hour; it is stored in
`localStorage` and sent only to `api.github.com`.

## Running it

Open `dashboard.html` directly, or:

```bash
docker compose up --build   # http://localhost:8080
```

```bash
python3 -m http.server 8899 # http://localhost:8899/dashboard.html
```
