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
        -- Force click in terminal
        click at {600, 400}
        delay 0.5
        -- Limit composer to 1 single concurrent job to prevent thread limit crash
        keystroke "composer config --global max-jobs 1 && cd ~/aviaj.com && composer install --no-dev --optimize-autoloader --ignore-platform-reqs --prefer-dist --no-interaction && php artisan key:generate && touch database/database.sqlite && php artisan migrate --force && chmod -R 775 storage bootstrap/cache database && chmod 664 database/database.sqlite && php artisan config:clear && php artisan cache:clear"
        delay 0.5
        key code 36 -- Return key
    end tell
end if
