-- Put command on clipboard
do shell script "echo 'cd ~/public_html && rm -rf temp-deploy && git clone https://github.com/manjot/aviaj.git temp-deploy && rsync -a temp-deploy/ . && rm -rf temp-deploy && composer install --no-dev --optimize-autoloader && cp .env.example .env && php artisan key:generate && php -r \"file_exists(\\'database/database.sqlite\\') || touch(\\'database/database.sqlite\\');\" && php artisan migrate --force && cat << \\'SEC\\' > .htaccess
<IfModule mod_rewrite.c>
   RewriteEngine On
   RewriteRule ^(.*)$ public/\\$1 [L]
</IfModule>
SEC' | pbcopy"

tell application "Google Chrome"
    activate
    set found to false
    repeat with w in windows
        set tabIndex to 1
        repeat with t in tabs of w
            if URL of t contains "webhostbox.net" and URL of t contains "terminal" then
                set active tab index of w to tabIndex
                set index of w to 1
                set found to true
                exit repeat
            end if
            set tabIndex to tabIndex + 1
        end repeat
        if found then exit repeat
    end repeat
    
    if found then
        display dialog "I have copied the deployment commands to your clipboard!\n\nJust press Cmd + V (Paste) and hit Enter inside your cPanel terminal to complete the live setup." buttons {"Ready!"} default button "Ready!" with icon note
    else
        display dialog "Could not locate the cPanel Terminal tab. Please ensure it is open in Chrome." buttons {"OK"} with icon warning
    end if
end tell
