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
        display dialog "I have copied the exact commands to your clipboard!\n\nJust press Cmd + V (Paste) and hit Enter inside your cPanel terminal to fix the error." buttons {"Ready!"} default button "Ready!" with icon note
    else
        display dialog "Could not locate the cPanel Terminal tab. Please ensure it is open in Chrome." buttons {"OK"} with icon warning
    end if
end tell
