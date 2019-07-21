on run {commands}
  tell application "iTerm2"
    tell current window
      create tab with profile "pc-jht-500g"
    end tell
    tell first session of current tab of current window
      write text  commands
    end tell
  end tell
end run

