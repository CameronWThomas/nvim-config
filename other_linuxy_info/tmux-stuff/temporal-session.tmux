
# Create Session
new-session -d -s temporal-session -n server

# Create Windows
new-window -n workflow-run
new-window -n worker-run

# Set up window 0
select-window -t 0
send-keys 'temporalWkspc' Enter
send-keys 'temporalServerStart' Enter


# Set up window 1
select-window -t 1
send-keys 'temporalWkspc' Enter
send-keys 'temporalWorkflowStart'


# Set up window 2
select-window -t 2
send-keys 'temporalWkspc' Enter
send-keys 'temporalWorkerStart'


