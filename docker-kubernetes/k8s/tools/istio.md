# ISTIO
- What is istio
- SideCar Containers
- Admission Controllers[mutate or validate]
- Why Do we need service mesh
- istio install and configure
- traffic management
- virtual services
- destination rules
- circut breaking
- mTLS
- Gateways
- Observability
- Service mesh and Ingress


Traffic b/w ingress and services is called North-South traffic
Traffic b/w services with in the k8s cluster is called East-West traffic

Istio help us traffic management b/w services in the k8s

communication b/w services happend over the http istio enahances capabilities of svc-to-svc communication mTLS

For example I have 2 micro services both having TLS certificate if both are trusting each other then only communication happend

- TLS
- mTLS

**istio features**
- mTLS
- advance deployment strategies[canary/AB]
- observability

sidecar[envoy-proxy] before istio the communication happend between container-svc-svc-container after istio enable one more extra container is called side car container that will intercept the traffic then only traffic was going to main container

container-->sidecar-->svc-->svc-->sidecar-->container both inbound and outbound traffic intercepted by side car container


