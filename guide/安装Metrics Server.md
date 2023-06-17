k8s可以通过top命令来查询pod和node的资源使用情况，如果直接运行该命令会报错，如下：

``` shell
[root@centos05 deployment]# kubectl top pod
W0306 15:23:24.990550    8247 top_pod.go:140] Using json format to get metrics. Next release will switch to protocol-buffers, switch early by passing --use-protocol-buffers flag
error: Metrics API not available
```

top命令依赖于metrics server，而k8s默认未安装该组件，下面介绍安装过程。

1.下载部署文件

```shell
[root@centos05 deployment]# wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

2.修改配置文件

把image的值改为国内镜像：

```yml
image: registry.cn-hangzhou.aliyuncs.com/google_containers/metrics-server:v0.6.2
```

如果你的k8s集群没有安装证书，还需要增加--kubelet-insecure-tls参数以便跳过验证，如下：

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

3.部署

```shell
[root@centos05 deployment]# kubectl apply -f components.yaml
```

4.验证安装结果

```shell
[root@centos05 deployment]# kubectl get pod -A | grep metrics
kube-system   metrics-server-fd9598766-8zphn       1/1     Running   0              89s
```

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