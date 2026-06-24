# Cloudflare — allow AI crawlers at the edge

`robots.txt` is advisory. Cloudflare can **block AI crawlers before they ever reach your
origin**, returning `402` (Pay-Per-Crawl) or `403` (a bot rule) regardless of what
`robots.txt` says. Work through these in order.

## 1. AI Scrapers & Crawlers setting
**Dashboard → your domain → Security → Bots → "AI Scrapers and Crawlers".**
- If set to **Block**, AI bots get a challenge/40x. Set it to **Allow** if you want
  citation visibility.
- New domains often onboard with this **on by default** — check it even if you never
  touched it.

## 2. Pay-Per-Crawl (HTTP 402)
If Pay-Per-Crawl is enabled, unlisted AI bots receive **402 Payment Required**.
- Either **disable** it, or
- **Allow / price at $0** the agents you want: `GPTBot`, `OAI-SearchBot`,
  `ChatGPT-User`, `ClaudeBot`, `anthropic-ai`, `PerplexityBot`, `Google-Extended`,
  `CCBot`, `Applebot-Extended`.

## 3. WAF / custom rules & Bot Fight Mode
- **Bot Fight Mode** challenges many automated agents — it can catch AI crawlers.
  Prefer **Super Bot Fight Mode** with "Verified bots" allowed, or add explicit skip
  rules.
- Add a WAF custom rule to **Skip** (allow) when
  `cf.client_bot` is a known good AI bot, or when the user-agent matches your allowlist.

## 4. Verify
From a machine outside your network:
```bash
curl -A "OAI-SearchBot/1.0 (+https://openai.com/searchbot)" -I https://yourdomain.com/
```
Expect `HTTP/2 200`. If you see `402` → Pay-Per-Crawl (step 2). `403`/`503` with a
challenge → a bot rule (steps 1, 3). Run [`../verify.sh`](../verify.sh) to test every
agent at once.

> Same logic applies to other CDNs/WAFs (Fastly, Akamai, AWS WAF, Vercel): find where
> bot management lives and allow the AI user-agents explicitly.
