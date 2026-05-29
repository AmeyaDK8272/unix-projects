#!/bin/bash
echo "Process started with PID $$"
RUNTIME=$((RANDOM % 30 + 10))
echo "Will run for $RUNTIME seconds then crash"
sleep $RUNTIME
echo "Process crashed!"
exit 1
