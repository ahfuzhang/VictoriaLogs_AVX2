
VictoriaLogs with AVX2.

The plan is to try using the avx2 instruction set to optimize performance based on the official VictoriaLogs version.

> I submitted a pull request to the VictoriaLogs team for an AVX2-accelerated implementation using Plan9 assembly, but they rejected it.
> 
> I completely understand. On one hand, Plan9 assembly is difficult to master; on the other hand, assembly optimization might not align with VictoriaLogs' product direction.
> 
> However, I personally need to quickly reduce the computational cost of logging in a production environment.
> 
> To bridge this gap, I plan to patch an existing version of VictoriaLogs, allowing some frequently accessed code to benefit from the AVX2 acceleration.

# How to use

1. Clone by version

```bash
make clone  # or make clone ver=v1.37.0
```

2. patch

```bash
make patch  # or make patch ver=v1.37.0
```

3. build

```bash
make build  # or make build ver=v1.37.0
```

4. docker build

```bash
make docker_build  # or make docker_build ver=v1.37.0
```

5. docker push

```bash
make docker_push  # or make docker_push ver=v1.37.0
```

6. diff

When you modify code, made a patch file:

```bash
make diff  # or make diff ver=v1.37.0
```

see: https://hub.docker.com/repository/docker/ahfuzhang/victoria-logs/general

# K8s deploy example

```yaml
apiVersion: operator.victoriametrics.com/v1
kind: VLSingle
metadata:
  name: singlenode-on-k8s
  namespace: logging
spec:
  extraEnvs:
    - name: GOMAXPROCS
      value: '2'
  image:
    pullPolicy: Always
    repository: docker.io/ahfuzhang/victoria-logs
    tag: v1.37.0-avx2
  replicaCount: 1
  resources:
    limits:
      cpu: 2
      memory: 2Gi
    requests:
      cpu: 500m
      memory: 500Mi
  retentionPeriod: 7d

```
