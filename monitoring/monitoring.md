# What is metrics
Periodical info or historical data of a events to understand about system

scraping = pull the metrics from different sources
dashbords = visualize the metricss for better understanding
alerts = fire the alers when the one of the metric at peak
prometheus = TSDB store the data with time stamps

- pod status how many time pod went to crashloopbackoff thoughout a day and what point of time
- deployment status
- application specific metics
  - Total nof http requests are received by appl at particular time
  - users signup
  - users deactivate  

abnormality in a particular time


NodeExprter = get nodes info
KubestateMetrics = k8s object metrics
/metrics = application level metrics






























































































1. Introduction to Prometheus and Grafana  
   - What is Prometheus?  
   - What is Grafana?  
   - Key differences between Prometheus and traditional monitoring tools  

2. Prometheus Architecture and Components  
   - Prometheus Server (Time-series database)  
   - PromQL (Prometheus Query Language)  
   - Exporters (NodeExporter, cAdvisor, Blackbox Exporter, etc.)  
   - Alertmanager (Handling alerts)  
   - Pushgateway (For short-lived jobs)  
   - Service Discovery (Static, Kubernetes, EC2, etc.)  

3. Setting Up Prometheus  
   - Installing Prometheus  
   - Configuring prometheus.yml  
   - Adding scrape jobs to collect metrics  

4. Exporting Metrics Using NodeExporter  
   - What is NodeExporter?  
   - Installing and configuring NodeExporter  
   - Scraping NodeExporter metrics with Prometheus  

5. EC2 Auto Service Discovery Instead of Configuring NodeExporter  
   - How EC2 auto discovery works in Prometheus  
   - Configuring EC2 service discovery in prometheus.yml  
   - Dynamically monitoring EC2 instances  

6. Prometheus Basic Queries (PromQL)  
   - Retrieving total disk size, remaining disk usage  
   - Fetching total and free memory  
   - Getting total CPU cores and CPU usage  
   - Querying network in/out metrics  
   - Monitoring disk I/O performance  

7. Alerting in Prometheus Using Alertmanager  
   - Installing and configuring Alertmanager  
   - Creating alert rules in Prometheus  
   - Sending alerts to Slack, Email, PagerDuty, etc.  

8. Visualizing Metrics with Grafana  
   - Installing Grafana  
   - Connecting Grafana to Prometheus  
   - Creating custom dashboards and panels  
   - Using PromQL queries in Grafana  

9. Advanced Topics  
   - Monitoring Kubernetes with Prometheus (Using Kube-state-metrics & cAdvisor)  
   - Using Thanos for long-term storage  
   - Performance tuning Prometheus for large-scale environments  
   - Security best practices in Prometheus and Grafana  


























# Prometheus & Grafana

Metrics are nothing but periodical or hisotrical data of the events to understand health of the system this is complate raw or numerical info so seed the metrics to monitoring system 

monitoring system can scrape the metrics and show the metrics in beatiful format using dash boards firing[notifiying] the alerts when something is wrong 

- cpu usage of nodes
- memory usage of nodes
- pod status how many time pod went to crashloopbackoff
- deploy status
- replicas of deployment
- http requests count

`alerts` are used to notify about utilization of system 

`prometheus` is a TSDB it will store the data with time stamps
`alertmanager` notify the engineers about metrics saturation
`grafana` visualization tool 

1:06:40

