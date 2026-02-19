#!/bin/bash

# Script to create a tmux temporal session
SESSION_NAME="temporal-session"

# Check if session already exists
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "Session $SESSION_NAME already exists. Attaching..."
    tmux attach-session -t $SESSION_NAME
    exit 0
fi

# Create new session with first window (server)
tmux new-session -d -s $SESSION_NAME -n "server"

# Create additional windows
tmux new-window -t $SESSION_NAME -n "workflow-run"
tmux new-window -t $SESSION_NAME -n "worker-run"

# Set up window 0 (server)
tmux select-window -t $SESSION_NAME:0
tmux send-keys -t $SESSION_NAME:server "temporalWkspc" Enter
tmux send-keys -t $SESSION_NAME:server "temporalServerStart" Enter

# Set up window 1 (workflow-run)
tmux select-window -t $SESSION_NAME:1
tmux send-keys -t $SESSION_NAME:workflow-run "temporalWkspc" Enter
tmux send-keys -t $SESSION_NAME:workflow-run "temporalWorkflowStart"

# Set up window 2 (worker-run)
tmux select-window -t $SESSION_NAME:2
tmux send-keys -t $SESSION_NAME:worker-run "temporalWkspc" Enter
tmux send-keys -t $SESSION_NAME:worker-run "temporalWorkerStart"

# Select the first window
tmux select-window -t $SESSION_NAME:server

# Attach to the session
tmux attach-session -t $SESSION_NAME
