# ConfigMap
- Used to store non-sensitive data like service configurations, nginx.conf, or application settings.
- If values are hardcoded inside a container, every change requires a full release cycle (build → deployment).
- ConfigMap decouples configuration from the container, allowing updates without rebuilding the image.

A ConfigMap is a Kubernetes object used to store configuration data in key-value pairs. It allows separating application configuration from container images, making applications more flexible and manageable.

- Stores non-sensitive configuration data such as environment variables, command-line arguments, and configuration files.
- Can be consumed by pods as environment variables, command-line arguments, or mounted as files.
- Helps manage dynamic configurations without rebuilding container images.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  APP_ENV: "production"
  APP_PORT: "8080"
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      env:
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: my-config
              key: APP_ENV
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      volumeMounts:
        - name: config-volume
          mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: my-config
```
# Secrets
- Used to store sensitive data like passwords, API keys, and TLS certificates.
- Data is Base64-encoded (not encrypted by default).
- Secret data is Base64-encoded, whereas ConfigMap data is stored as plain text.
- Provides a more secure way to manage confidential data compared to ConfigMaps.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  username: dXNlcm5hbWU=  # Base64 encoded "username"
  password: cGFzc3dvcmQ=  # Base64 encoded "password"
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      env:
        - name: SECRET_USERNAME
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: username
        - name: SECRET_PASSWORD
          valueFrom:
            secretKeyRef:
              name: my-secret
              key: password
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: my-container
      image: nginx
      volumeMounts:
        - name: secret-volume
          mountPath: "/etc/secret"
          readOnly: true
  volumes:
    - name: secret-volume
      secret:
        secretName: my-secret
```  

### Difference Between ConfigMap and Secret 
| Feature        | ConfigMap | Secret |
|---------------|----------|--------|
| Purpose | Stores non-sensitive data | Stores sensitive data |
| Encoding | Plain text | Base64-encoded |
| Use Case | Application config (e.g., URLs, ports) | Passwords, API keys, TLS certs |
| Security | Less secure | More secure (can be encrypted in etcd) |
