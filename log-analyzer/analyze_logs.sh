#!/bin/bash

#______________________________________

#LOG ANALYZER
# Analyzes a log file and generates report

#________________________________________

LOGFILE="app.log"
REPORT="report.txt"

#Check if log file exists
if [ ! -f "$LOGFILE" ]; then
   echo "Error: $LOGFILE not found!"
   exit 1
fi

echo "Analyzing $LOGFILE ...."
echo ""

#--1. Count total lines
TOTAL=$(wc -l < $LOGFILE)

#--2. Count each log level
ERRORS=$(grep -c "ERROR" $LOGFILE)
WARNINGS=$(grep -c "WARNING" $LOGFILE)
INFOS=$(grep -c "INFO" $LOGFILE)

#--3. Most common error messsage
TOP_ERROR=$(grep "ERROR" $LOGFILE | awk '{$1=$2=""; print $0}' | sort | uniq -c | sort -rn | head -1)

#--4. Most common warning
TOP_WARNING=$(grep "WARNING" $LOGFILE | awk '{$1=$2=""; print $0}' | sort | uniq -c | sort -rn | head -1)

#--5. Most active hour
PEAK_HOUR=$(awk '{print $2}' $LOGFILE | awk -F: '{print $1}' | sort | uniq -c | sort -rn | head -1)
#______________________________________

#Generate Report

#______________________________________
{
echo "====================================="
echo "    LOG ANALYSIS REPORT"
echo "====================================="
echo "File Analyzed : $LOGFILE"
echo "Generated At : $(date)"
echo "-------------------------------------"
echo ""
echo "__SUMMARY_____________________"
echo "Total Entries : $TOTAL"
echo "Errors        : $ERRORS"
echo "Warnings      : $WARNINGS"
echo "Info          : $INFOS"
echo ""
echo "____TOP ISSUES_____"
echo "Most Common Error  : $TOP_ERROR"
echo "Most Common Warning: $TOP_WARNING"
echo ""
echo "_____PEAK ACTIVITY______"
echo "Business Hour : $PEAK_HOUR:00"
echo ""
echo "__ERROR BREAKDOWN__"
grep "ERROR" $LOGFILE | awk '{$1=$2=""; print $0}' | sort | uniq -c | sort -rn
echo ""
echo "__WARNING BREAKDOWN__"
grep "WARNING" $LOGFILE | awk '{$1=$2=""; print $0}' | sort | uniq -c | sort -rn
echo "===================================================="
} | tee $REPORT

echo ""
echo "Report saved to $REPORT"
