# Observability
Observability is a whole thing
- What & Why Observability and pillers of observability

Get the internal state of the system[application+infrastructure+networkin]
- application working as expected or any failures,resounrces consumption
- any node failures get the logs and resournces consumption
- get the latency failures of requests as well as success of http requests

- What is the disk utilization of my node last 24 hours [ get info like resounrces are underutilized or overutilized or saturated]
- cpu utilization or memory utilization

- no of api calls are succeed or failed out of particulart no of requests
What[metrics]


- You can analyze why https requests are failed why pod failed agian and again what is the reason for failure 
- Memory leak in a application 
Why[logs]

- why http requests are failing you can get complete tracing

3 pillers of observability
- metrics[Monitoring][Prometheus&Grafana]+alerts
- logging[logs][Elastic Stack]
- traces[kiali&Jaegar]

client ---> LB ---> frontend svc ---> frontend ---> backend svc ---> backend ---> DB

- Tracing is getting info about complete travel of http request from client to DB determine the how latency b/w componets we can easily findout any breakouts of http request in b/w client to DB


# Metrics
- Gives the historical data of the events, event can be cpu,memory,disk,n/w,http requests
- Last 30 mins, last one hour data you can determinte how cpu at particular time 

- cpu utilization normal , went to peak at this time

# Logs
- info
- debug
- error
- trace


SLA[SeerviceLevelAgreement] = Agreement b/w organization and client 
- You can define Objectives[nothing but promises to the customer] like
  - 99.99% platform i avialable means 0.1 % application going down
  - out of 1000 http requests 995 requests respond back 30 ms with 200 status code 

SLO[ServiceLevelObjectives]

SLI[ServiceLevelIndicators]


Developers need to instrument the metrics,logs and traces
DevOps Engineers do the implementation part[setup monitoring,logging and tracing]

Metrics are nothing but periodical or hisotrical data of the events to understand health of the system this is complate raw or numerical info so seed the metrics to monitoring system 

scrape the metrics 
