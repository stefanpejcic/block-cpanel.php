#!/bin/bash

FILE="/usr/local/cpanel/php/cpanel.php"
echo "Checking $FILE file.."

read -r -d '' BLOCK <<'EOF'
if (!isset($_ENV['CPANEL']) && !isset($_SERVER['REMOTE_USER'])) {
    header('HTTP/1.1 403 Forbidden');
    exit('Message support@your-domain.com if you need API access!');
}
EOF

if [[ ! -f "$FILE" ]]; then
  echo "Error: $FILE not found! - is this cpanel?"
  exit 1
fi

echo "Setting read permisisons to file.."
chmod +r "$FILE"

if grep -Fq "your-domain.com" "$FILE"; then
  echo "Already blocked"
else
  tmpfile=$(mktemp)
  awk -v block="$BLOCK" '
    BEGIN { inserted=0 }
    {
      print $0
      if (!inserted && $0 ~ /^<\?php/) {
        print block "\n"
        inserted=1
      }
    }
  ' "$FILE" > "$tmpfile" && mv "$tmpfile" "$FILE"
  echo "Added"
fi

