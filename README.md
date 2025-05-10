# Server Log Analysis Script

## Overview
Bash script that processes web server logs (`cleaned_access_log.csv`) to generate performance and security insights.

## log_analyzer.sh

## Key Features

### 📊 Traffic Analysis
- Total request count
- GET/POST method distribution 
- Unique IP address identification

### 🚨 Error Detection
- Failed request (4xx/5xx) count
- Failure rate percentage
- Status code breakdown (200-500)

### 👥 User Activity
- Most active IP addresses
- Top requesters by method (GET/POST)

### ⏱ Temporal Patterns
- Daily request averages
- Peak traffic time windows
- High-failure periods (by day/hour)

### 🔍 Actionable Outputs
- Auto-generated security recommendations
- Performance optimization suggestions
- Priority failure timeframes

# log_analysis_report.txt
- Containing Script's analysis & suggestion output

# dataset.ipnyb
- Data pre-processing
- Metadata about the logs with data sample
- ### Data source : - [Web Server Access Logs on Kaggle](https://www.kaggle.com/datasets/eliasdabbas/web-server-access-logs)

- # Task report
- steps of creating this task
- brief explaination of the code
- output analysis
