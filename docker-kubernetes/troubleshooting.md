# Troubleshooting a Pod in Kubernetes

When deploying an application as a Pod in Kubernetes, it’s important to verify whether the Pod is running successfully or encountering issues. Below are the key steps to troubleshoot a Pod and ensure smooth deployment.

## 1. Describe the Pod
The first step is to check the status of the Pod using the `kubectl describe pod` command:

```sh
kubectl describe pod <pod-name> -n <namespace>
```

This command provides detailed information, including events, container states, and errors such as:
- Probe failures (Liveness, Readiness, or Startup probes)
- ConfigMap or Secret mount failures
- Image pull errors
- Insufficient resources

If the Pod is failing, the description will often point to the root cause.

## 2. Check the Logs
If the Pod is running but the application inside it is failing, inspect the logs:

```sh
kubectl logs <pod-name> -n <namespace> --previous  # View logs of a crashed container
kubectl logs <pod-name> -n <namespace>  # View live logs
```

Logs can reveal application-level errors such as missing environment variables, incorrect configurations, or dependency failures.

## 3. Verify Secrets and ConfigMap Mounts
If the application relies on Secrets or ConfigMaps, ensure they are mounted correctly:

```sh
kubectl get secret <secret-name> -n <namespace> -o yaml
kubectl get configmap <configmap-name> -n <namespace> -o yaml
```

Additionally, check within the Pod if the files are mounted properly:

```sh
kubectl exec -it <pod-name> -n <namespace> -- cat /path/to/mounted/file
```

If the data is missing or incorrect, check the Deployment or StatefulSet YAML to confirm proper volume mounts.

## 4. Check Probe Execution
Kubernetes uses probes to check the health of a container. If the probes are failing, the container might restart frequently or fail to start at all. View the probe configuration in the Deployment YAML:

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 10
```

Common probe issues:
- **Initial delay too short**: If `initialDelaySeconds` is too low, the container might not have enough time to initialize before the first health check.
- **Incorrect probe path or port**: Ensure the application exposes the correct health check endpoint.
- **Network policies blocking access**: If probes fail due to connection issues, check Network Policies or Service configurations.

## 5. Ensure Deployment and Service Alignment
A common mistake is a mismatch between the Deployment and Service configurations. Verify that:
- The Service targets the correct Pod labels:

```yaml
selector:
  app: my-app
```

- The Deployment labels match the Service selector:

```yaml
metadata:
  labels:
    app: my-app
```

- The Service is exposed on the correct port and protocol.

To debug service-related issues, use:

```sh
kubectl get svc -n <namespace>
kubectl get endpoints -n <namespace>
```

If the Service has no endpoints, it means no Pods match the selector.

## Conclusion
By following these steps, you can systematically debug Kubernetes Pods and resolve common deployment issues. Always start by describing the Pod, checking logs, validating configurations, and ensuring probe execution before investigating networking or Service-related problems. Happy debugging!

