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
    delay 0.5
    tell application "System Events"
        -- Force focus terminal
        click at {600, 400}
        delay 0.5
        -- Run the complete single-threaded sequential deployment for lp.ajath.ae
        keystroke "git config --global pack.threads 1 && git config --global indexpack.threads 1 && cd ~/lp.ajath.ae && rm -rf temp-deploy && git clone https://github.com/manjot/aviaj.git temp-deploy && rsync -a temp-deploy/ . && rm -rf temp-deploy && COMPOSER_MAX_PARALLEL_HTTP=1 composer install --no-dev --optimize-autoloader --ignore-platform-reqs --prefer-dist --no-interaction && cp .env.example .env && php artisan key:generate && touch database/database.sqlite && php artisan migrate --force && chmod -R 775 storage bootstrap/cache database && chmod 664 database/database.sqlite && php artisan config:clear && php artisan cache:clear"
        delay 0.5
        key code 36 -- Return key
    end tell
end if
