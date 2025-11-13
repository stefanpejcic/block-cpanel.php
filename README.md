# 🚫 block /usr/local/cpanel/php/cpanel.php
Block access to the LiveAPI PHP class for cPanel users (prevents terminal / PHP-script abuse)

A simple script to block access to cPanel's LiveAPI PHP class so that calls originating from a user's website or terminal are denied, while legitimate calls originating from the cPanel UI (and third-party plugins) are allowed.

---

cPanel exposes programmatic access via:

* [`/usr/local/cpanel/php/cpanel.php`](https://api.docs.cpanel.net/guides/guide-to-the-liveapi-system/guide-to-the-liveapi-system-php-class/) — PHP class used by UAPI
* [`/usr/local/cpanel/bin/uapi`](https://api.docs.cpanel.net/openapi/cpanel/overview/) — CLI wrapper for API calls

Many malicious or poorly written WordPress plugins and arbitrary PHP scripts abuse `/usr/local/cpanel/php/cpanel.php` to view or change a user’s cPanel data (create mailboxes, add forwarders, etc.). At the same time, third‑party cPanel integrations (Softaculous, WP Toolkit, SitePad, etc.) legitimately use this file — so a naive block (`chmod 0600`) breaks those plugins.

This script patches `/usr/local/cpanel/php/cpanel.php` to perform an additional check: if the call is coming from the cPanel UI (or an allowed internal context), it permits the request; if it’s coming from a site’s PHP or a shell session, access is denied.

## Install

To use it, run the following command as `root` on a cpanel server:

```bash
cd /root && git clone https://github.com/stefanpejcic/block-cpanel.php && bash block-cpanel.php/setup.sh
```

`setup.sh` will apply the modification to `/usr/local/cpanel/php/cpanel.php`, and hook into `/scripts/postupcp` so it runs after each cPanel’s update process (not overwritten on update).

## Uninstall

1. Edit `/usr/local/cpanel/php/cpanel.php` and remove lines form the start of the file:
   ```if (!isset($_ENV['CPANEL']) && !isset($_SERVER['REMOTE_USER'])) {
      header('HTTP/1.1 403 Forbidden');
      exit('Message support@your-domain.com if you need API access!');
   }   
   ```
2. Edit `/scripts/postupcp` and remove the line:
   ```bash
   cd /root/block-cpanel.php && git pull ; bash /root/block-cpanel.php/setup.sh #https://github.com/stefanpejcic/block-cpanel.php
   ```
3. Delete folder:
   ```bash
   rm -rf /root/block-cpanel.php   
   ```
