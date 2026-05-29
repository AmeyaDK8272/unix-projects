#!/bin/bash
LOGFILE="app.log"
> $LOGFILE

ERRORS=("Database failed" "Timeout exceeded" "Out of memory" "File not found" "Null pointer exception")
WARNINGS=("Disk space low" "High CPU Usage" "Slow query" "Cache miss")
INFOS=("User logged in" "User logged out" "Request processed" "Cache refreshed" "App started")

for i in $(seq 1 100)
do
	DAY=$(printf "%02d" $((RANDOM % 28 + 1)))
	HOUR=$(printf "%02d" $((RANDOM % 24)))
	MIN=$(printf "%02d" $((RANDOM % 60)))
	TIME="2024-01-$DAY $HOUR:$MIN:00"
	BUCKET=$((i%10))
	if [ "$BUCKET" -ge 1 ] && [ "$BUCKET" -le 3 ]
	then
		MSG=${ERRORS[$((RANDOM % 5))]}
		echo "$TIME ERROR $MSG" >> $LOGFILE
	elif 
		[ "$BUCKET" -ge 4 ] && [ "$BUCKET" -le 5 ]
	then
		MSG=${WARNINGS[$((RANDOM % 4))]}
		echo "$TIME WARNING $MSG" >> $LOGFILE
	else
		MSG=${INFOS[$((RANDOM % 5))]}
		echo "$TIME INFO $MSG" >> $LOGFILE
	fi
done
echo "Done! Log file generated."
