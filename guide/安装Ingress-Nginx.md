
# 下载安装文件

首先，需要匹配Ingress-nginx版本和kubernetes版本。
在[https://github.com/kubernetes/ingress-nginx](https://github.com/kubernetes/ingress-nginx)可以找到，如下图所示：

![Image text](./image/ingress-k8s-version.png)

笔者用的k8s版本是v1.21.2，需要安装Ingress-nginx的v1.3.1版本，下载如下文件：

```shell
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.1/deploy/static/provider/cloud/deploy.yaml
```

# 替换镜像

查看该文件用到了哪些镜像：

```shell
[root@centos05 deployment]# cat deploy.yaml | grep image
        image: registry.k8s.io/ingress-nginx/controller:v1.3.1@sha256:54f7fe2c6c5a9db9a0ebf1131797109bb7a4d91f56b9b362bde2abd237dd1974
        imagePullPolicy: IfNotPresent
        image: registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.3.0@sha256:549e71a6ca248c5abd51cdb73dbc3083df62cf92ed5e6147c780e30f7e007a47
        imagePullPolicy: IfNotPresent
        image: registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.3.0@sha256:549e71a6ca248c5abd51cdb73dbc3083df62cf92ed5e6147c780e30f7e007a47
        imagePullPolicy: IfNotPresent
```

可以看出，所用到的镜像不在docker hub中，在registry.k8s.io中，由于国内的网络问题，拉取不到该仓库的镜像。不过，有个开源项目对registry.k8s.io仓库的镜像做了搬运工作，地址如下：

[https://github.com/anjia0532/gcr.io_mirror](https://github.com/anjia0532/gcr.io_mirror)

在此，非常感谢该项目的作者，按照文档的说明，我们使用其中的一种方式：

```
registry.k8s.io/{namespace}/{image}:{tag} ==> anjia0532/google-containers.{namespace}.{image}:{tag}
```

按照以上的格式，我们把deploy.yaml文件中用的镜像地址分别替换：

```
registry.k8s.io/ingress-nginx/controller:v1.3.1@sha256:54f7fe2c6c5a9db9a0ebf1131797109bb7a4d91f56b9b362bde2abd237dd1974 ->
anjia0532/google-containers.ingress-nginx.controller:v1.3.1
```

```
registry.k8s.io/ingress-nginx/kube-webhook-certgen:v1.3.0@sha256:549e71a6ca248c5abd51cdb73dbc3083df62cf92ed5e6147c780e30f7e007a47 ->
anjia0532/google-containers.ingress-nginx.kube-webhook-certgen:v1.3.0
```

# 安装

保存以后，部署ingress-nginx:

```shell
[root@centos05 deployment]# kubectl apply -f deploy.yaml 
namespace/ingress-nginx created
serviceaccount/ingress-nginx created
serviceaccount/ingress-nginx-admission created
role.rbac.authorization.k8s.io/ingress-nginx created
role.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrole.rbac.authorization.k8s.io/ingress-nginx created
clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
rolebinding.rbac.authorization.k8s.io/ingress-nginx created
rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
configmap/ingress-nginx-controller created
service/ingress-nginx-controller created
service/ingress-nginx-controller-admission created
deployment.apps/ingress-nginx-controller created
job.batch/ingress-nginx-admission-create created
job.batch/ingress-nginx-admission-patch created
ingressclass.networking.k8s.io/nginx created
validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created
```

查看结果：

```shell
[root@centos05 deployment]# kubectl get pods -n ingress-nginx -o wide
NAME                                        READY   STATUS      RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
ingress-nginx-admission-create-fq2kq        0/1     Completed   0          11s   10.32.1.89   centos06   <none>           <none>
ingress-nginx-admission-patch-fkphb         0/1     Completed   1          11s   10.32.1.90   centos06   <none>           <none>
ingress-nginx-controller-5c79d9494c-rh5rn   0/1     Running     0          11s   10.32.1.91   centos06   <none>           <none>
```

访问nginx：

```shell
[root@centos05 deployment]# curl http://10.32.1.91
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

安装成功。