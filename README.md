# AI Crawler Allowlist

[![License: MIT](https://img.shields.io/badge/License-MIT-D4B483.svg)](LICENSE)
[![robots.txt](https://img.shields.io/badge/robots.txt-ready-0B0B0B.svg)](robots.txt)

> A perfect on-page AEO build is **invisible if AI crawlers can't reach your origin.**
> This repo is a copy-paste `robots.txt`, a Cloudflare edge checklist, and a one-command
> verifier so ChatGPT, Perplexity, Gemini, Copilot and Claude can actually read — and
> cite — your site.

## The problem

Two silent failure modes keep well-optimised sites out of AI answers:

1. **`robots.txt` omission.** AI crawlers use their own user-agents (`OAI-SearchBot`,
   `PerplexityBot`, `ClaudeBot`, …). If your rules don't address them, edge cases and
   over-broad `Disallow` blocks can shut them out.
2. **The edge layer.** CDNs increasingly block AI crawlers **by default** — Cloudflare's
   managed "Block AI Scrapers and Crawlers" rule returns **HTTP 403**, and Pay-Per-Crawl
   returns **402**, to AI bots on many onboardings. Your `robots.txt` can say *Allow* while
   the edge silently turns the crawler away before it ever reaches origin.

This repo addresses both.

## What's inside

| File | Purpose |
|------|---------|
| [`robots.txt`](robots.txt) | Annotated allowlist for the AI search/citation crawlers (drop in, edit the `Sitemap:` line) |
| [`cloudflare/SETUP.md`](cloudflare/SETUP.md) | Allow AI crawlers at the Cloudflare edge; disable the 402 trap |
| [`verify.sh`](verify.sh) | Curl your site as each AI bot and print the status code (expect `200`) |

## Quick start

1. Copy [`robots.txt`](robots.txt) to your site root, update the `Sitemap:` URL.
2. Work through [`cloudflare/SETUP.md`](cloudflare/SETUP.md) (or your CDN's equivalent).
3. Confirm:
   ```bash
   ./verify.sh https://yourdomain.com
   ```
   Every row should read `200`. A `402` means Pay-Per-Crawl is blocking; `403` means a
   WAF/bot rule is.

   > **Read the result correctly.** `verify.sh` sends each bot's user-agent from *your*
   > machine, so it tests user-agent-level blocking only. Real crawlers are also validated
   > by IP/ASN — a `403` is a strong signal to investigate, but confirm in your CDN's bot
   > analytics or server logs that *verified* bots get `200`.

## Allow citation, control training (optional)

The baseline `robots.txt` allows the bots that get you **cited**. Some teams want
citation visibility but opt out of **model-training** corpora. To do that, keep the
search/citation bots (`OAI-SearchBot`, `ChatGPT-User`, `PerplexityBot`, `ClaudeBot`)
allowed, and set the training-oriented agents (`GPTBot`, `Google-Extended`,
`Applebot-Extended`, `CCBot`) to `Disallow: /`. Comments in `robots.txt` mark which is
which. Note `Google-Extended` governs **Gemini/Vertex training only** — it does not
affect Googlebot or Google Search indexing.

## Built by Flow.OS

Maintained by [**Flow.OS**](https://flowos.digital) — AI visibility & first-party
attribution for premium brands across Australia & APAC.

Free: check whether AI engines can see your brand → **AI Visibility Score** at
https://flowos.digital

## License

[MIT](LICENSE).
