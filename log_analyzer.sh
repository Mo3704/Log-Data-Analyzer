#!/bin/bash

# Check if input file exists
if [ ! -f "cleaned_access_log.csv" ]; then
    echo "Error: cleaned_access_log.csv not found!" > log_analysis_report.txt
    exit 1
fi

# Initialize report file
report_file="log_analysis_report.txt"
{
echo "Log File Analysis Report"
echo "Generated on: $(date +"%Y-%m-%d %H:%M:%S")"
echo "Data Source: cleaned_access_log.csv"
echo ""

# 1. Request Counts
echo "=== BASIC STATISTICS ==="
total_requests=$(wc -l < cleaned_access_log.csv)
echo "Total Requests: $total_requests"

get_requests=$(awk -F',' '$3 == "GET" {count++} END {print count}' cleaned_access_log.csv)
post_requests=$(awk -F',' '$3 == "POST" {count++} END {print count}' cleaned_access_log.csv)
echo "GET Requests: $get_requests"
echo "POST Requests: $post_requests"

# 2. Unique IP Addresses
unique_ips=$(cut -d',' -f1 cleaned_access_log.csv | sort -u | wc -l)
echo "Unique IP Addresses: $unique_ips"
echo ""

# 3. Failure Requests
echo "=== FAILURE ANALYSIS ==="
failed_requests=$(awk -F',' '$6 >= 400 && $6 <= 500 {count++} END {print count}' cleaned_access_log.csv)
failure_percentage=$(awk -v failed=$failed_requests -v total=$total_requests 'BEGIN {printf "%.2f", (failed/total)*100}')
echo "Failed Requests: $failed_requests"
echo "Failure Percentage: $failure_percentage%"
echo ""

# 4. Top Users
echo "=== TOP USERS ==="
echo "Most Active IP Overall:"
cut -d',' -f1 cleaned_access_log.csv | sort | uniq -c | sort -nr | head -1
echo ""

echo "Top GET Requester:"
awk -F',' '$3 == "GET" {print $1}' cleaned_access_log.csv | sort | uniq -c | sort -nr | head -1
echo ""

echo "Top POST Requester:"
awk -F',' '$3 == "POST" {print $1}' cleaned_access_log.csv | sort | uniq -c | sort -nr | head -1
echo ""

# 5. Enhanced Temporal Analysis
echo "=== TEMPORAL ANALYSIS ==="

# Daily Averages
total_days=$(awk -F',' '{print substr($2,2,11)}' cleaned_access_log.csv | sort -u | wc -l)
avg_daily_requests=$(awk -v total=$total_requests -v days=$total_days 'BEGIN {printf "%.2f", total/days}')
echo "Average Daily Requests: $avg_daily_requests"
echo ""

# Failure Days (Top 3)
echo "=== TOP FAILURE DAYS ==="
awk -F',' '$6 >= 400 && $6 <= 500 {print substr($2,2,11)}' cleaned_access_log.csv | sort | uniq -c | sort -nr | head -3
echo ""

# Peak Traffic Times (Top 5)
echo "=== PEAK TRAFFIC TIMES ==="
awk -F',' '{print $2}' cleaned_access_log.csv | sort | uniq -c | sort -nr | head -5
echo ""

# Failed Request Times (Top 5)
echo "=== FAILURE PEAK TIMES ==="
awk -F',' '$6 >= 400 && $6 <= 500 {print $2}' cleaned_access_log.csv | sort | uniq -c | sort -nr | head -5
echo ""

# 6. Status Code Breakdown
echo "=== STATUS CODE BREAKDOWN ==="
awk -F',' '$6 >= 200 && $6 <= 500 {count[$6]++} END {for (code in count) print count[code], code}' cleaned_access_log.csv | sort -nr
echo ""

# 7. Dynamic Suggestions
echo "=== SUGGESTIONS ==="
top_failure_day=$(awk -F',' '$6 >= 400 && $6 <= 500 {print substr($2,2,11)}' cleaned_access_log.csv | sort | uniq -c | sort -nr | head -1)
top_failure_hour=$(awk -F',' '$6 >= 400 && $6 <= 500 {print $2}' cleaned_access_log.csv | sort | uniq -c | sort -nr | head -1)
top_get_ip=$(awk -F',' '$3 == "GET" {print $1}' cleaned_access_log.csv | sort | uniq -c | sort -nr | head -1)
top_post_ip=$(awk -F',' '$3 == "POST" {print $1}' cleaned_access_log.csv | sort | uniq -c | sort -nr | head -1)

echo "1. Immediate Actions:"
echo "   - Investigate failures on $top_failure_day"
echo "   - Check server logs during peak failure time: $top_failure_hour"
echo ""
echo "2. Security Review:"
echo "   - Monitor GET requests from IP: $top_get_ip"
echo "   - Monitor POST requests from IP: $top_post_ip"
echo ""
echo "3. Performance Optimization:"
echo "   - Scale resources during peak traffic times shown above"
echo "   - Review endpoints returning 4xx/5xx errors in status breakdown"
} > $report_file

echo "Analysis complete. Results saved to $report_file"