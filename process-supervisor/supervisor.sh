#!/bin/bash

PROCESS="dummy_process.sh"
LOG_FILE="/home/akulkarni/process-supervisor/supervisor.log"
MAX_RESTARTS=5
RESTART_COUNT=0
CHECK_INTERVAL=5

log()
{
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1" | tee -a $LOG_FILE
}

start_process()
{
    bash $PROCESS &
    PID=$!
    log "INFO: Started $PROCESS with PID $PID"
}

log "INFO: Supervisor started"
log "INFO: Monitoring $PROCESS"
log "INFO: Max restarts allowed: $MAX_RESTARTS"
log "------------------------------------------------"

start_process

while true
do
     sleep $CHECK_INTERVAL

    if kill -0 $PID 2>/dev/null
    then
         log "INFO: Process $PID is running normally"
    else
         log "WARNING: Process $PID has stopped!"

         RESTART_COUNT=$((RESTART_COUNT+1))
         log "INFO: Restart attempt $RESTART_COUNT of $MAX_RESTARTS"

         if [ "$RESTART_COUNT" -gt "$MAX_RESTARTS" ]
         then
             log "ERROR: Max restarts reached. Giving up!"
             log"-------------------------------------------"
             exit 1
         fi

         log "INFO: Restarting $PROCESS ..."
         start_process
    fi
done
