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
        -- Click at {600, 500} which is the middle of the terminal area
        click at {600, 500}
        delay 1.0
        -- Send Ctrl+C to cancel any active state
        keystroke "c" using {control down}
        delay 0.5
        -- Send the reset command
        keystroke "cd ~/aviaj.com && git fetch origin && git reset --hard origin/rollback-php83 && /opt/cpanel/ea-php83/root/usr/bin/php artisan config:clear && /opt/cpanel/ea-php83/root/usr/bin/php artisan cache:clear && /opt/cpanel/ea-php83/root/usr/bin/php artisan view:clear"
        delay 0.5
        -- Press Return key
        key code 36
    end tell
end if

delay 5.0
do shell script "screencapture /Users/manjotsingh/.gemini/antigravity/brain/0ffd9276-9383-4dd4-9d79-00c0caf8a296/screenshot_deploy_focus.png"
