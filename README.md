# Unix Fundamentals Projects

A collection of Unix/Linux projects built from scratch on CentOS 9 Stream to demonstrate understanding of Unix Fundametals.

## Projects

###1. Log Analyzer
Generates fake log files and analyzes them using grep, awk and sed.
-Counts errors, warnings, info messages
-Finds most common errors
-Generates summary report

###2. Backup Tool
Backs up folders with compression, tinestamping and rotation.
-Uses tar for compression
-Rotates old backups (keeps last 5 )
-Checks disk space before backup
-Logs every backup run

###3. Process Supervisor
Monitors processes and restarts them if they crash.
-Detects process crashes using kill -0
-Restarts automatically
-Tracks restart count
-Stops after max restarts reached

###4. ETL Pipeine
Fetches live weather data from API and generates CSV report
-Extracts data using curl
-Transforms JSON using jq
-Loads into CSV format
-Calculates temperature and humidity stats

##Tools Used
- bash, grep, awk, sed
-tar, rsync, find
-curl, jq
-ps, kill, signals

##How to run

###Log Analyzer 
cd log-analyzer
bash generate-logs.sh
bash analyze_logs.sh

### Backup Tool
cd backup-tool
bash backup.sh

### Process Supervisor
cd process-supervisor
bash supervisor.sh

### ETL Pipeline
cd etl-pipeline
bash etl.sh

## Author 
Ameya Kulkarni

(Completed with help of Claude)  
