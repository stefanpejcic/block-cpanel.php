# block-cpanel.php
Blocks access to  LiveAPI PHP class for cpanel users (terminal and php scripts)


In cpanel you can from PHP view/manipulate user's data using:
- `/usr/local/cpanel/php/cpanel.php` - PHP class used for UAPI
- `/usr/local/cpanel/bin/uapi` - for API calls and terminal commands

`/usr/local/cpanel/php/cpanel.php` is often used by malicious WP plugins and php scirpts to view user's cpanel data, create new email accounts, setup forwarders, etc.
But it is also legitimeatley used by third-party cpanel plugins like Softaculous, WPToolkit, Sitepad, etc.

Soi simply blocking the access ot this file will also break those plugins.

The foloowing scirpt will simplt edit the file to add a chekc if call is communig from withing cPanel UI, like form a plugin and allow it, else if form user's terminal or php script on their webiste, it denies access.

