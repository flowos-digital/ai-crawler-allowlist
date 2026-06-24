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

# Representative, real user-agent strings for the major AI crawlers.
UAS=(
  "OAI-SearchBot/1.0 (+https://openai.com/searchbot)"
  "Mozilla/5.0 (compatible; GPTBot/1.1; +https://openai.com/gptbot)"
  "Mozilla/5.0 (compatible; ChatGPT-User/1.0; +https://openai.com/bot)"
  "Mozilla/5.0 (compatible; ClaudeBot/1.0; +claudebot@anthropic.com)"
  "Mozilla/5.0 (compatible; PerplexityBot/1.0; +https://perplexity.ai/perplexitybot)"
  "Mozilla/5.0 (compatible; Google-Extended)"
  "Mozilla/5.0 (compatible; CCBot/2.0; +https://commoncrawl.org/faq/)"
  "Mozilla/5.0 (compatible; Applebot/0.1; +http://www.apple.com/go/applebot)"
)

printf "%-22s %s\n" "BOT" "STATUS"
printf "%-22s %s\n" "----------------------" "------"
for ua in "${UAS[@]}"; do
  code=$(curl -A "$ua" -s -o /dev/null -w "%{http_code}" -L --max-time 20 "$URL" || echo "ERR")
  label="${ua%%[;/ ]*}"
  printf "%-22s %s\n" "$label" "$code"
done

echo
echo "Expect 200. 402 = Cloudflare Pay-Per-Crawl blocking the bot. 403/503 = WAF/bot rule."
echo "See cloudflare/SETUP.md to fix."
