# block /usr/local/cpanel/php/cpanel.php
Block access to the LiveAPI PHP class for cPanel users (prevents terminal / PHP-script abuse)

A simple script to block access to cPanel's LiveAPI PHP class so that calls originating from a user's website or terminal are denied, while legitimate calls originating from the cPanel UI (and third-party plugins) are allowed.

## Why?
cPanel exposes programmatic access via:

* [`/usr/local/cpanel/php/cpanel.php`](https://api.docs.cpanel.net/guides/guide-to-the-liveapi-system/guide-to-the-liveapi-system-php-class/) — PHP class used by UAPI
* [`/usr/local/cpanel/bin/uapi`](https://api.docs.cpanel.net/openapi/cpanel/overview/) — CLI wrapper for API calls

Many malicious or poorly written WordPress plugins and arbitrary PHP scripts abuse `/usr/local/cpanel/php/cpanel.php` to view or change a user’s cPanel data (create mailboxes, add forwarders, etc.). At the same time, third‑party cPanel integrations (Softaculous, WP Toolkit, SitePad, etc.) legitimately use this file — so a naive block (`chmod 0600`) breaks those plugins.

This script patches `/usr/local/cpanel/php/cpanel.php` to perform an additional check: if the call is coming from the cPanel UI (or an allowed internal context), it permits the request; if it’s coming from a site’s PHP or a shell session, access is denied.

---

## How?

Run the following commands as `root` on a cpanel server:

```bash
cd /root && git clone https://github.com/stefanpejcic/block-cpanel.php && bash block-cpanel.php/run.sh
```

`run.sh` will apply the modification to `/usr/local/cpanel/php/cpanel.php`. [Review the script before running](/blob/main/run.sh) if you want to inspect the changes first.

To automatically reapply after cPanel updates, add a line to `/scripts/postupcp` so the repo pulls and the setup runs after cPanel’s update process:

```bash
line_to_add="cd /root/block-cpanel.php/ && git pull ; bash /root/block-cpanel.php/run.sh #https://github.com/stefanpejcic/block-cpanel.php"

if ! grep -qF "$line_to_add" /scripts/postupcp; then
  echo "$line_to_add" >> /scripts/postupcp
fi
```
