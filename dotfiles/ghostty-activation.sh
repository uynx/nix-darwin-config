#!/usr/bin/env sh

export PATH="/Users/uynx/.nix-profile/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

CURRENT_WORKSPACE=$(aerospace list-workspaces --focused | awk '{print $1}')
WINDOW_ID=$(aerospace list-windows --workspace "$CURRENT_WORKSPACE" | tac | awk '$3 == "Ghostty" {print $1; exit}')

# Grouped session launcher to prevent window mirroring.
# We ensure the base 'main' session exists, then ensure windows 2 and 3 exist if needed.
# Then we attach to a workspace-specific grouped session 'main-$CURRENT_WORKSPACE'.
TMUX_LAUNCHER="
  if ! tmux has-session -t main 2>/dev/null; then
    tmux new-session -d -s main -n 1
  fi

  tmux set-option -t main renumber-windows off 2>/dev/null

  if ! tmux list-windows -t main -F '#I' 2>/dev/null | grep -q \"^$CURRENT_WORKSPACE\$\"; then
    if [ \"$CURRENT_WORKSPACE\" = \"3\" ]; then
      if ! tmux list-windows -t main -F '#I' 2>/dev/null | grep -q \"^2\$\"; then
        tmux new-window -d -t main:2 -n 2 2>/dev/null
      fi
    fi
    tmux new-window -d -t main:$CURRENT_WORKSPACE -n \"$CURRENT_WORKSPACE\" 2>/dev/null
  fi

  if tmux has-session -t \"main-$CURRENT_WORKSPACE\" 2>/dev/null; then
    tmux select-window -t \"main-$CURRENT_WORKSPACE\":$CURRENT_WORKSPACE 2>/dev/null
    tmux attach-session -t \"main-$CURRENT_WORKSPACE\"
  else
    tmux new-session -t main -s \"main-$CURRENT_WORKSPACE\" \\; set-option destroy-unattached on \\; select-window -t :$CURRENT_WORKSPACE
  fi
"

if [ -n "$WINDOW_ID" ]; then
  aerospace focus --window-id "$WINDOW_ID"
  # If we focused an existing window, make sure the tmux window for this workspace is created and selected
  tmux set-option -t main renumber-windows off 2>/dev/null
  if ! tmux list-windows -t main -F '#I' 2>/dev/null | grep -q "^$CURRENT_WORKSPACE$"; then
    if [ "$CURRENT_WORKSPACE" = "3" ]; then
      if ! tmux list-windows -t main -F '#I' 2>/dev/null | grep -q "^2$"; then
        tmux new-window -d -t main:2 -n 2 2>/dev/null
      fi
    fi
    tmux new-window -d -t main:$CURRENT_WORKSPACE -n "$CURRENT_WORKSPACE" 2>/dev/null
  fi
  tmux select-window -t "main-$CURRENT_WORKSPACE":$CURRENT_WORKSPACE 2>/dev/null
else
  # Open Ghostty running the tmux launcher command in sh (POSIX)
  ghostty -e sh -c "$TMUX_LAUNCHER"
fi
