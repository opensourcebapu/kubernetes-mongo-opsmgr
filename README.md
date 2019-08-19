# Kubernetes Mongo OpsManager Deployment

## Deploying using skaffold

Refer to the values settings below. Deploy with [Skaffold](https://github.com/GoogleContainerTools/skaffold) using the following command
```bash
skaffold deploy
```

Default deployment Configuration for skaffold.yaml
```yml
apiVersion: skaffold/v1beta13
kind: Config
deploy:
  helm:
    releases:
    - name: test
      namespace: mongodb
      chartPath: mongo-opsmgr-helm
      #wait: true
      valuesFiles:
      - mongo-opsmgr-helm/values.yaml
      #recreatePods will pass --recreate-pods to helm upgrade
      #recreatePods: true
      #overrides builds an override values.yaml file to run with the helm deploy
      #overrides:
      # some:
      #   key: someValue
      #setValues get appended to the helm deploy with --set.
      #setValues:
        #some.key: someValue
```

## Helm Chart info

## Prerequisites Details

* Kubernetes 1.9+
* PV support on the underlying infrastructure if user intends on using persistent volumes

## Chart Details

This chart implements MongoDB Ops Manager [MongoDB Ops Manager](https://docs.opsmanager.mongodb.com/current/)
using a Kubernetes deployment based on the [opensourcebapu/mongodb-opsmgr-centos](https://hub.docker.com/r/opensourcebapu/mongodb-opsmgr-centos) image.

## Installing the Chart

To install the chart with the release name `test`:

``` console
helm install -n test . -f <values-file>.yaml
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter                           | Description                                                               | Default                                             |
| ----------------------------------- | ------------------------------------------------------------------------- | --------------------------------------------------- |
| `replicaCount`                      | Number of replicas in the deployment (for HA in the future)               | `1`                                                 |
| `image.name`                        | MongoDB Ops Manager image name                                            | `opensourcebapu/mongodb-opsmgr-centos`              |
| `image.tag`                         | image tag                                                                 | `latest`                                            |
| `image.pullPolicy`                  | image pull policy                                                         | `IfNotPresent`                                      |
| `service.type`                      | Kubernetes service type                                                   | `ClusterIP`                                         |
| `service.clusterIP`                 | Kubernetes clusterIP service IP (none for headless)                       | `None`                                              |
| `service.port`                      | Kubernetes service port                                                   | `8080`                                              |
| `env.MMS_USER`                      | Ops Manager username (default mongodb-mms, refer to Dockerfile)           | `mongodb-mms`                                       |
| `env.ENC_KEY_PATH`                  | Ops Manager username gen.key path                                         | `/etc/mongodb-mms/gen.key`                          |
| `appdb.host`                        | Ops Manager backing mongodb URI (URI:port)                                | `mongodb-replicaset-0:27017,mongodb-replicaset-1:27017,mongodb-replicaset-2:27017`                        |
| `ingress.enabled`                   | If `true` enable creation of ingress resoource                            | `false`                                             |
| `resources.limits.cpu`              | Pod cpu limit                                                             | `2000m`                                             |
| `resources.limits.memory`           | Pod memory limit                                                          | `2Gi`                                               |
| `resources.limits.cpu`              | Pod cpu requests                                                          | `500m`                                              |
| `resources.limits.memory`           | Pod memory requests                                                       | `2Gi`                                               |
| `nodeSelector`                      | Node labels for pod assignment                                            | `{}`                                                |
| `affinity`                          | Node/pod affinities                                                       | `{}`                                                |
| `securityContext.enabled`           | Enable security context                                                   | `true`                                              |
| `securityContext.fsGroup`           | Group ID for the container                                                | `999`                                               |
| `securityContext.runAsUser`         | User ID for the container                                                 | `998`                                               |
| `securityContext.runAsNonRoot`      |                                                                           | `true`                                              |
| `persistentVolume.keyVol.enabled`    If `true`, create pvc for gen key storage                                  | `true`                                              |
| `persistentVolume.keyVol.storageClass`     | Persistent volume storage class                                    | ``                                                  |
| `persistentVolume.keyVol.accessModes`      | Persistent volume access modes                                     | `[ReadWriteOnce]`                                   |
| `persistentVolume.keyVol.size`             | Persistent volume size                                             | `50Mi`                                              |
| `persistentVolume.releaseVol.enabled`    If `true`, create pvc for mongodb releases storage                     | `true`                                              |
| `persistentVolume.releaseVol.storageClass`     | Persistent volume storage class                                | ``                                                  |
| `persistentVolume.releaseVol.accessModes`      | Persistent volume access modes                                 | `[ReadWriteOnce]`                                   |
| `persistentVolume.releaseVol.size`             | Persistent volume size                                         | `5Gi`                                              |
| `tolerations`                       | List of node taints to tolerate                                           | `[]`                                                |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

``` console
helm install -n <release-name> . -f <custom-values-file>.yaml
```

### Scaling

HA mode is WIP
