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