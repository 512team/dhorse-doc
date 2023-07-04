##### 执行如下命令，所有节点都执行

```shell
kubeadm reset
```

##### 初始化集群，仅在master(centos01)上执行

```shell
[root@centos01 opt]# kubeadm init --apiserver-advertise-address 192.168.109.130 --image-repository registry.aliyuncs.com/google_containers --kubernetes-version v1.27.1 --pod-network-cidr=10.244.0.0/16

...
...
...

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.109.130:6443 --token osh87v.zvo010kamsr8esmp \
	--discovery-token-ca-cert-hash sha256:ff4607c7c194e9f756b1eb509e64d2d926b5f8f9556a85c3c14a2d25add28230
```

其中，
–apiserver-advertise-address：通告侦听地址
–image-repository：指定镜像地址使用阿里云的，默认会使用谷歌镜像
–kubernetes-version：指定当前的kubernetes的版本
–pod-network-cidr=10.244.0.0/16：flannel网络的固定地址范围

仔细阅读kubeadm init执行的结果，根据提示，还需要进行3步操作

1.笔者用的是root用户，仅在master节点执行

```shell
[root@centos01 opt]# vim /etc/profile
#在最后一行增加
export KUBECONFIG=/etc/kubernetes/admin.conf
```

生效环境变量
```shell
[root@centos01 opt]# source /etc/profile
```

2.安装网络插件，可以选择calico或flannel，这里选择安装flannel，仅在master节点执行

下载安装文件

```shell
[root@centos01 opt]# wget https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

修改配置

```shell
[root@centos01 opt]# vim kube-flannel.yml
#修改Network项的值，改为和--pod-network-cidr一样的值
"Network": "10.244.0.0/16"
#由于有时国内网络的问题，需要修改image的地址，把所有的docker.io改为dockerproxy.com
#共需要修改3处，两个值
image: dockerproxy.com/flannel/flannel:v0.22.0
image: dockerproxy.com/flannel/flannel-cni-plugin:v1.1.2
```

安装网络插件
```shell
[root@centos01 opt]# kubectl apply -f kube-flannel.yml
```

验证安装
```
[root@centos01 opt]# kubectl get pods -n kube-flannel
NAME                    READY   STATUS    RESTARTS       AGE
kube-flannel-ds-dfngh   1/1     Running   17 (13m ago)   6d1h
kube-flannel-ds-qll8g   1/1     Running   12 (13m ago)   6d1h
```

3.其他节点加入集群，非master节点都执行

```shell
[root@centos02 opt]# kubeadm join 192.168.109.130:6443 --token osh87v.zvo010kamsr8esmp --discovery-token-ca-cert-hash sha256:ff4607c7c194e9f756b1eb509e64d2d926b5f8f9556a85c3c14a2d25add28230
```

##### 验证安装结果，仅在master节点执行

```shell
[root@centos01 opt]# kubectl get nodes
NAME       STATUS   ROLES           AGE    VERSION
centos01   Ready    control-plane   134m   v1.27.1
centos02   Ready    <none>          133m   v1.27.1
```

```shell
[root@centos01 opt]# kubectl get pods -n kube-system
NAME                               READY   STATUS    RESTARTS   AGE
coredns-7bdc4cb885-l4vs2           1/1     Running   0          9m3s
coredns-7bdc4cb885-wzc8x           1/1     Running   0          9m3s
etcd-centos01                      1/1     Running   0          9m18s
kube-apiserver-centos01            1/1     Running   0          9m18s
kube-controller-manager-centos01   1/1     Running   0          9m19s
kube-proxy-m92hr                   1/1     Running   0          28s
kube-proxy-pv4hw                   1/1     Running   0          9m3s
kube-scheduler-centos01            1/1     Running   0          9m18s
```

重启一遍所有服务器节点，有可能会暴露出来隐藏的问题，再次验证以上结果，仍然正常。

最后，推荐一个发布应用的平台[https://gitee.com/i512team/dhorse](https://gitee.com/i512team/dhorse)，是一个以应用为中心的云原生DevOps系统，能够实现持续集成、持续部署、微服务治理等功能，主要特点：部署简单、操作简洁、功能快速。