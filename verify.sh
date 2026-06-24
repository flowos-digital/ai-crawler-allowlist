#!/usr/bin/env bash
# verify.sh — can AI crawlers actually reach your origin?
# Curls your site as each AI bot and prints the HTTP status. Expect 200.
# Usage:  ./verify.sh https://yourdomain.com
# Built by Flow.OS · https://flowos.digital · MIT
set -euo pipefail

URL="${1:-}"
if [ -z "$URL" ]; then
  echo "Usage: $0 https://yourdomain.com"
  exit 1
fi

# "Label|User-Agent" — representative real UA strings for the major AI crawlers.
UAS=(
  "OAI-SearchBot|OAI-SearchBot/1.0 (+https://openai.com/searchbot)"
  "GPTBot|Mozilla/5.0 (compatible; GPTBot/1.1; +https://openai.com/gptbot)"
  "ChatGPT-User|Mozilla/5.0 (compatible; ChatGPT-User/1.0; +https://openai.com/bot)"
  "ClaudeBot|Mozilla/5.0 (compatible; ClaudeBot/1.0; +claudebot@anthropic.com)"
  "PerplexityBot|Mozilla/5.0 (compatible; PerplexityBot/1.0; +https://perplexity.ai/perplexitybot)"
  "Google-Extended|Mozilla/5.0 (compatible; Google-Extended)"
  "CCBot|Mozilla/5.0 (compatible; CCBot/2.0; +https://commoncrawl.org/faq/)"
  "Applebot|Mozilla/5.0 (compatible; Applebot/0.1; +http://www.apple.com/go/applebot)"
)

printf "%-18s %s\n" "BOT" "STATUS"
printf "%-18s %s\n" "------------------" "------"
for entry in "${UAS[@]}"; do
  label="${entry%%|*}"
  ua="${entry#*|}"
  code=$(curl -A "$ua" -s -o /dev/null -w "%{http_code}" -L --max-time 20 "$URL" || echo "ERR")
  printf "%-18s %s\n" "$label" "$code"
done

cat <<'EOF'

Expect 200. 402 = Cloudflare Pay-Per-Crawl. 403/503 = a WAF/bot rule. See cloudflare/SETUP.md.

NOTE — what this does and does NOT prove:
  This sends each bot's user-agent string from THIS machine's IP, so it tests
  USER-AGENT-level blocking only. Real crawlers are also validated by IP/ASN ("verified
  bots"), so a 403 here can mean either:
    (a) the real, verified bot is blocked too (genuine invisibility), or
    (b) only impersonators are blocked, while the verified bot still gets through.
  Treat a 403 as a strong signal to investigate, then confirm in your CDN's bot analytics
  or server logs that VERIFIED bots receive 200.
EOF
