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
end tell

if found then
    delay 1
    tell application "System Events"
        -- type the deploy script and press return
        keystroke "rm -rf temp-deploy && git clone https://github.com/manjot/aviaj.git temp-deploy && rsync -a temp-deploy/ . && rm -rf temp-deploy && composer install --no-dev --optimize-autoloader && cp .env.example .env && php artisan key:generate && php -r \"file_exists('database/database.sqlite') || touch('database/database.sqlite');\" && php artisan migrate --force"
        delay 0.5
        key code 36 -- Return key
        delay 5
        -- write the .htaccess file
        keystroke "cat << 'EOF' > .htaccess
<IfModule mod_rewrite.c>
   RewriteEngine On
   RewriteRule ^(.*?)$ public/$1 [L]
</IfModule>
EOF"
        delay 0.5
        key code 36 -- Return key
    end tell
end if
