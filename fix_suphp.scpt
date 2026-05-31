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
        -- apply standard suPHP secure permissions (755 for dirs, 644 for files)
        keystroke "find ~/lp.ajath.ae -type d -exec chmod 755 {} \\; && find ~/lp.ajath.ae -type f -exec chmod 644 {} \\; && chmod -R 755 ~/lp.ajath.ae/storage ~/lp.ajath.ae/bootstrap/cache && chmod 755 ~/lp.ajath.ae/database && chmod 644 ~/lp.ajath.ae/database/database.sqlite && php artisan config:clear && php artisan cache:clear"
        delay 0.5
        key code 36 -- Return key
    end tell
end if
