完成安装k8s集群以后，推荐使用[https://github.com/512team/dhorse](https://github.com/512team/dhorse)发布应用。

## 准备环境

准备两台服务器节点，如果需要安装虚拟机，可以参考[《wmware和centos安装过程》](https://blog.csdn.net/huashetianzu/article/details/109510266)

| 机器名 | IP | 角色 | CPU | 内存 |
| :----: | :----: | :----: | :----: | :----: |
| centos01 | 192.168.109.130 | master | 4核 | 2G |
| centos02 | 192.168.109.131 | node | 4核 | 2G |


##### 设置主机名，所有节点都执行

```shell
vim /etc/hosts
#增加
192.168.109.130 centos01
192.168.109.131 centos02
```

##### 关闭防火墙，所有节点都执行

```shell
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
vim /etc/selinux/config
#修改SELINUX的值
SELINUX=disabled
```

##### 关闭swap内存，所有节点都执行

```shell
swapoff -a
vim /etc/fstab
# 将该行注释掉
#/dev/mapper/cs-swap swap
```

##### 配置网桥，所有节点都执行

1.修改参数
```shell
vim /etc/sysctl.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables 	= 1
net.ipv4.ip_forward 				= 1
vm.swappiness 						= 0
```

2.然后，加载如下两个模块，所有节点都执行
```shell
modprobe ip_vs_rr
modprobe br_netfilter
```

3.生效配置

```shell
[root@centos01 opt]# sysctl -p
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
vm.swappiness = 0

```

## 安装containerd

以下步骤所有节点都执行。

##### 安装

```shell
wget https://github.com/containerd/containerd/releases/download/v1.7.2/containerd-1.7.2-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-1.7.2-linux-amd64.tar.gz
```

##### 修改配置

```shell
mkdir /etc/containerd
containerd config default > /etc/containerd/config.toml
vim /etc/containerd/config.toml
#SystemdCgroup的值改为true
SystemdCgroup = true
#由于国内下载不到registry.k8s.io的镜像，修改sandbox_image的值为：
sandbox_image = "registry.aliyuncs.com/google_containers/pause:3.9"
```

##### 启动服务

```shell
mkdir -p /usr/local/lib/systemd/system
wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mv containerd.service /usr/local/lib/systemd/system
systemctl daemon-reload
systemctl enable --now containerd
```

##### 验证安装

```shell
[root@centos01 opt]# ctr version
Client:
  Version:  v1.7.2
  Revision: 0cae528dd6cb557f7201036e9f43420650207b58
  Go version: go1.20.4

Server:
  Version:  v1.7.2
  Revision: 0cae528dd6cb557f7201036e9f43420650207b58
  UUID: 747cbf1b-17d4-4124-987a-203d8c72de7c

```

## 安装runc

以下步骤所有节点都执行。

##### 准备文件
```
wget https://github.com//opencontainers/runc/releases/download/v1.1.7/runc.amd64
chmod +x runc.amd64
```

##### 查找containerd安装时已安装的runc所在的位置，如果不存在runc文件，则直接进行下一步

```shell
[root@centos01 opt]# which runc
/usr/bin/runc
```

##### 替换上一步的结果文件

```shell
mv -f runc.amd64 /usr/bin/runc
```

##### 验证安装
```shell
[root@centos01 opt]# runc -v
runc version 1.1.7
commit: v1.1.7-0-g860f061b
spec: 1.0.2-dev
go: go1.20.3
libseccomp: 2.5.4
```

## 安装kubernetes

##### 添加阿里云的kubernetes源，所有节点都执行

```shell
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

##### 安装最新版，所有节点都执行

```shell
yum install -y kubeadm kubelet kubectl
```

##### 开机自启动，所有节点都执行
```shell
systemctl enable kubelet
```

##### 验证安装，所有节点都执行

```shell
[root@centos01 opt]# kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"27", GitVersion:"v1.27.1", GitCommit:"4c9411232e10168d7b050c49a1b59f6df9d7ea4b", GitTreeState:"clean", BuildDate:"2023-04-14T13:20:04Z", GoVersion:"go1.20.3", Compiler:"gc", Platform:"linux/amd64"}
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

建议重启一遍所有服务器节点，有可能会暴露出来隐藏的问题，再次验证以上结果，仍然正常。

最后，推荐一个部署应用的平台: [https://github.com/512team/dhorse](https://github.com/512team/dhorse)

演示地址：[http://dhorse-demo2.512.team](http://dhorse-demo2.512.team)
