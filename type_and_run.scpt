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
        -- type the fix commands and press return
        keystroke "cd ~/aviaj.com && touch database/database.sqlite && php artisan migrate --force && chmod 775 database && chmod 664 database/database.sqlite && php artisan config:clear && php artisan cache:clear"
        delay 0.5
        key code 36 -- Return key
    end tell
end if
