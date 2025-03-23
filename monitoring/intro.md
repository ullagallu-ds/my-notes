# What is Observability Why Do we need Observability
Observability = get the feedback whole system
Get the info about internal state of the system
- app[working as expected are there any failures ]
- infra
- network[latency+http traffic]
- storage[disk utilization]

Some Examples[What]:
- What is the disk utilization of my node in k8s last 24 hours[uderutilized/overutilizated]
- CPU utlization
- Memory Utilization
- 100 https how many requests are failed or success and latency of each http request

SomeExamples[Why]:
- Reason for application failures
- http requests failed
- application uses more ammount of memory[memory leak]

SomeExamples[How]:
- Traces complete journey of HTTP request figure out the where exactly http request failed
- Traces help us to track which component causes falire

3 pillers of observability
- Metrics[Gives historical data out of 100 http requests 5 are failed]
- Logs[using log info you can findout exact reason for request failure using hisorical data what happend 10.00 clock ]
- Traces[complete request flow from client to DB gives lateency b/w components]

Metrics = Gives hisotrical data of the events[cpu,memory,disk,netowrk,https requests] last 30 mins
- overutilized
- underutilized
- partial
If cpu utilization reaches 70% fire the alert to the enginees
Dashboards are used to visualize the metrics
some times utilization very nominal [peak,normal]

Logs = event info 
- Info log
- debug log
- error log
- trace log

Traces = Gives extensive info where exactly problem debug troubleshoot and fix the issue

SLA = Client and Vendor have some objectives make the promises to the client 
- ensure 99.99% platform will be available 
- out of 1000 requests atleast 995 requests succeded respond back 30 milli seconds with 200

TO fulfill promises to the customer we have strong observability plaform to get feesback about internal of a system 

Observability = collective effective of developers and ops engineers
developers instrument the application[info,debug,error] and also implement the traces + metrics
ops engineer implement the tools to monitor applications

# Block Box Monitoring
- End user can test application
# White Box Monotring
- application internal monitoring
- CPU,RAM,DISK I/O,Network I/O
latency = Time to respond to our requests

Four Golden Signals
- Latency[response time]
- Traffic[how much traffic is coming and demand on system]
- Errors[requests are failed]
- Saturation[Check the cpu and ram]

- centralized monitoring

Prometheus monotring tool that stores the data in TSDB we hisotrical and live data we can analyze easily 

pull model have agents and push model does not have agents

up[1m]

I have the server using node exporter ip:9090 monitor the node same add another scrape config now i can monitori application like ip:8080

- job_name: "nodes"
  static_configs: 
    - targets : ["172.31.43.191:9100"]
      labels:
        node: node-1
The fourth one is **Summary**.  

### Recap of Prometheus Metrics Types:  
1. **Counter** – Monotonic increasing value (e.g., request count, error count).  
2. **Gauge** – Value that can go up and down (e.g., memory usage, active connections).  
3. **Histogram** – Measures event durations or sizes, providing a count and buckets for distribution.  
4. **Summary** – Similar to a histogram but provides quantiles (e.g., 95th percentile response time).  

Histograms and Summaries both track distributions, but histograms use predefined buckets, while summaries calculate quantiles dynamically.

x-axis time y-axis value[data]

Legend {{name}} dash board creation

monitor if any thing goes wrong raise incident