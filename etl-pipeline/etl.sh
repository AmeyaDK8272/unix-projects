#!/bin/bash

CITIES="Mumbai Delhi Bangalore Chennai Kolkata"
OUTPUT_CSV="weather_report.csv"
LOG_FILE="etl.log"
SUMMARY_FILE="summary.txt"

log()
{
echo "$(date +"%Y-%m-%d %H:%M:%S") $1" | tee -a $LOG_FILE
}

log "INFO: ETL Pipeline started"
log "INFO: Cities to process: $CITIES"
log "---------------------------------------------------------------"

echo "City, Temperature_C, FeelsLike_C, Humidity_%, Wind_kmph, Condition" > $OUTPUT_CSV

for CITY in $CITIES
do
log "INFO: Extracting data for $CITY"
RAW=$(curl -s "https://wttr.in/$CITY?format=j1")

if [ -z "RAW" ]
then
log "ERROR: No data received for $CITY"
continue
fi

TEMP=$(echo $RAW | jq -r ".current_condition[0].temp_C")
FEELS=$(echo $RAW | jq -r ".current_condition[0].FeelsLikeC")
HUMIDITY=$(echo $RAW |jq -r ".current_condition[0].humidity")
WIND=$(echo $RAW | jq -r ".current_condition[0].windspeedKmph")
CONDITION=$(echo $RAW | jq -r ".current_condition[0].weatherDesc[0].value")

log "INFO: $CITY -> Temp:${TEMP}C Humidity:${HUMIDITY}% Wind:${WIND}kmph"
echo "$CITY,$TEMP,$FEELS,$HUMIDITY,$WIND,$CONDITION" >> $OUTPUT_CSV
done

log "-----------------------------------------------------------------------"
log "INFO: All cities processed"
log "INFO: Generating summary..."

{
echo "========================================================"
echo "              WEATHER ETL REPORT"
echo "========================================================"
echo "Generated At : $(date)"
echo "Cities       : $CITIES"
echo ""
echo "__________RAW DATA_____________"
awk -F, "NR==1{next} {printf \"%-12s Temp:%-4sC Feels:%-4sC Humidity:%-4s%% Wind:%-4skmph %s\n\",\$1,\$2,\$3,\$4,\$5,\$6}" $OUTPUT_CSV
echo ""
echo "_________TEMPERATURE STATS_____"
awk -F, "NR>1{sum+=\$2; count++; if(\$2+0>max+0)max=\$2; if(min==\"\"||(\$2+0<min+0))min=\$2} END{printf \"Average : %.1f C\nHighest : %s C\nLowest : %s C\n\", sum/count, max, min}" $OUTPUT_CSV
echo ""
echo "________HUMIDITY STATS__________"
awk -F, "NR>1{sum+=\$4; count++; if(\$4+0>max+0)max=\$4; if(min==\"\"||(\$4+0<min+0))min=\$4} END{printf \"Average : %.1f%%\nHighest : %s%%\nLowest : %s%%\n\", sum/count, max, min}" $OUTPUT_CSV
echo ""
echo "=========================================================="
} | tee $SUMMARY_FILE

log "INFO: Summary saved to $SUMMARY_FILE"
log "INFO: CSV saved to $OUTPUT_CSV"
log "INFO: ETL Pipeline completed!"
log "------------------------------------------"
