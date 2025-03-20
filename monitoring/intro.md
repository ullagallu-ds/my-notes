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

