k8s可以通过top命令来查询pod和node的资源使用情况，如果直接运行该命令，如下所示。

``` shell
[root@centos05 deployment]# kubectl top pod
W0306 15:23:24.990550    8247 top_pod.go:140] Using json format to get metrics. Next release will switch to protocol-buffers, switch early by passing --use-protocol-buffers flag
error: Metrics API not available
```

top命令依赖于metrics server，而k8s默认未安装该组件，下面详细介绍使用过程。

安装过程
1. 下载部署文件

[下载components.yaml文件](https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml)

2. 修改镜像地址

将部署文件中镜像地址修改为国内的地址，大概在部署文件的第140行。
原配置是：

```yml
image: k8s.gcr.io/metrics-server/metrics-server:v0.6.2
```

修改后的配置是：

```yml
image: registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.6.2
```

3. 部署metrics server

```shell
[root@centos05 deployment]# kubectl create -f components.yaml
serviceaccount/metrics-server created
clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
clusterrole.rbac.authorization.k8s.io/system:metrics-server created
rolebinding.rbac.authorization.k8s.io/metrics-server-auth-reader created
clusterrolebinding.rbac.authorization.k8s.io/metrics-server:system:auth-delegator created
clusterrolebinding.rbac.authorization.k8s.io/system:metrics-server created
service/metrics-server created
deployment.apps/metrics-server created
apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
```

查看metric server的运行情况，发现探针问题：Readiness probe failed: HTTP probe failed with statuscode: 500

```shell
[root@centos05 deployment]# kubectl get pods -n kube-system | grep metrics
kube-system   metrics-server-6ffc8966f5-84hbb      0/1     Running   0              2m23s
[root@centos05 deployment]# kubectl describe pod metrics-server-6ffc8966f5-84hbb -n kube-system
```

进而查看pod的日志：

```shell
[root@centos05 deployment]# kubectl logs metrics-server-6ffc8966f5-84hbb -n kube-system 
I1010 16:27:46.228594       1 serving.go:342] Generated self-signed cert (/tmp/apiserver.crt, /tmp/apiserver.key)
I1010 16:27:46.633494       1 secure_serving.go:266] Serving securely on [::]:4443
I1010 16:27:46.633585       1 requestheader_controller.go:169] Starting RequestHeaderAuthRequestController
I1010 16:27:46.633616       1 shared_informer.go:240] Waiting for caches to sync for RequestHeaderAuthRequestController
I1010 16:27:46.633653       1 dynamic_serving_content.go:131] "Starting controller" name="serving-cert::/tmp/apiserver.crt::/tmp/apiserver.key"
I1010 16:27:46.634221       1 tlsconfig.go:240] "Starting DynamicServingCertificateController"
W1010 16:27:46.634296       1 shared_informer.go:372] The sharedIndexInformer has started, run more than once is not allowed
I1010 16:27:46.634365       1 configmap_cafile_content.go:201] "Starting controller" name="client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file"
I1010 16:27:46.634370       1 shared_informer.go:240] Waiting for caches to sync for client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file
I1010 16:27:46.634409       1 configmap_cafile_content.go:201] "Starting controller" name="client-ca::kube-system::extension-apiserver-authentication::client-ca-file"
I1010 16:27:46.634415       1 shared_informer.go:240] Waiting for caches to sync for client-ca::kube-system::extension-apiserver-authentication::client-ca-file
E1010 16:27:46.641663       1 scraper.go:140] "Failed to scrape node" err="Get \"https://192.168.100.22:10250/metrics/resource\": x509: cannot validate certificate for 192.168.100.22 because it doesn't contain any IP SANs" node="k8s-slave2"
E1010 16:27:46.645389       1 scraper.go:140] "Failed to scrape node" err="Get \"https://192.168.100.20:10250/metrics/resource\": x509: cannot validate certificate for 192.168.100.20 because it doesn't contain any IP SANs" node="k8s-master"
E1010 16:27:46.652261       1 scraper.go:140] "Failed to scrape node" err="Get \"https://192.168.100.21:10250/metrics/resource\": x509: cannot validate certificate for 192.168.100.21 because it doesn't contain any IP SANs" node="k8s-slave1"
I1010 16:27:46.733747       1 shared_informer.go:247] Caches are synced for RequestHeaderAuthRequestController 
I1010 16:27:46.735167       1 shared_informer.go:247] Caches are synced for client-ca::kube-system::extension-apiserver-authentication::client-ca-file 
I1010 16:27:46.735194       1 shared_informer.go:247] Caches are synced for client-ca::kube-system::extension-apiserver-authentication::requestheader-client-ca-file 
E1010 16:28:01.643646       1 scraper.go:140] "Failed to scrape node" err="Get \"https://192.168.100.22:10250/metrics/resource\": x509: cannot validate certificate for 192.168.100.22 because it doesn't contain any IP SANs" node="k8s-slave2"
E1010 16:28:01.643805       1 scraper.go:140] "Failed to scrape node" err="Get \"https://192.168.100.21:10250/metrics/resource\": x509: cannot validate certificate for 192.168.100.21 because it doesn't contain any IP SANs" node="k8s-slave1"
E1010 16:28:01.646721       1 scraper.go:140] "Failed to scrape node" err="Get \"https://192.168.100.20:10250/metrics/resource\": x509: cannot validate certificate for 192.168.100.20 because it doesn't contain any IP SANs" node="k8s-master"
I1010 16:28:13.397373       1 server.go:187] "Failed probe" probe="metric-storage-ready" err="no metrics to serve"
```

可以确定pod异常是因为：Readiness Probe 探针检测到 Metris 容器启动后对 http Get 探针存活没反应，具体原因是：cannot validate certificate for 192.168.100.22 because it doesn't contain any IP SANs" node="k8s-slave2"

查看 metrics-server 的文档（https://github.com/kubernetes...），有如下一段说明：

Kubelet certificate needs to be signed by cluster Certificate Authority (or disable certificate validation by passing 
--kubelet-insecure-tls to Metrics Server)
意思是：kubelet 证书需要由集群证书颁发机构签名(或者通过向 Metrics Server 传递参数 --kubelet-insecure-tls 来禁用证书验证)。
由于是测试环境，我们选择使用参数禁用证书验证，生产环境不推荐这样做！！！

在大概 139 行的位置追加参数：--kubelet-insecure-tls，修改后内容如下：

```yml
spec:
  containers:
  - args:
    - --cert-dir=/tmp
    - --secure-port=4443
    - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
    - --kubelet-use-node-status-port
    - --metric-resolution=15s
    - --kubelet-insecure-tls
```

再次部署文件：

```shell
[root@centos05 deployment]# kubectl apply -f components.yaml
```

查看pod已经正常运行：

```shell
[root@centos05 deployment]# kubectl get pod -A | grep metrics
kube-system   metrics-server-fd9598766-8zphn       1/1     Running   0              89s
```

执行kubectl top命令成功：
```shell
[root@centos05 deployment]# kubectl top pod
NAME                                CPU(cores)   MEMORY(bytes)   
hello-1-qa-dhorse-6fc54647c-5zkjc   501m         133Mi 
```

```shell
[root@centos05 deployment]# kubectl top node
NAME       CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%     
centos05   192m         4%     1610Mi          59%         
centos06   107m         2%     854Mi           50%  
```