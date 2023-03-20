Check API server connectivity every 10mins
Test both internal kubernetes.default.svc and the provided ControlPlane loadBalancer IP/Address

```
export EXTERNAL_APISERVER_ADDRESS=<CP_LOADBALANCER_IP>:6443
```
```
cat <<EOF | kubectl --kubeconfig apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: api-lb-address
  namespace: default
data:
  EXTERNAL_APISERVER: ${EXTERNAL_APISERVER_ADDRESS}
EOF
```
```
cat <<EOF | kubectl --kubeconfig apply -f -
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: check-api-connectivity
  namespace: default
spec:
  selector:
    matchLabels:
      name: check-api-connectivity
  template:
    metadata:
      labels:
        name: check-api-connectivity
    spec:
      containers:
      - name: dnsutils
        image: alexchrisramos/check_api_loop:0.0.3
        args: [/bin/bash, -c, 
              ./check_api.sh]
        envFrom:
        - configMapRef:
            name: api-lb-address
        resources:
          limits:
            memory: 500Mi
          requests:
            cpu: 100m
            memory: 500Mi
EOF
```
