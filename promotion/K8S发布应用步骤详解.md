# 前言

首先以SpringBoot应用为例介绍一下k8s的发布步骤。

1.从代码仓库下载代码，比如GitLab；

2.接着是进行打包，比如使用Maven；

3.编写Dockerfile文件，把步骤2产生的包制作成镜像；

4.上传步骤3的镜像到远程仓库，比如Harhor；

5.编写Deployment文件；

6.提交Deployment文件到k8s集群；

从以上步骤可以看出，发布需要的工具和环境至少包括：代码仓库（GitLab）、打包环境（Maven）、镜像制作（Docker）、镜像仓库（Harbor）、k8s集群等。
当前，也可以借助一些开源的系统来发布你的应用，比如：Jenkins、DHorse([https://github.com/512team/dhorse](https://github.com/512team/dhorse))等。

# 详细步骤

假如有一个名为Hello的SpringBoot应用，服务端口是8080，并且有一个/hello接口。

## 打包

这里直接从GitLab下载到本地，执行maven打包命令，这里打为Jar包：

```shell
mvn clean package
```

完成以后，生成的包为：hello-1.0.0.jar

## 制作镜像

以下步骤在具有Docker环境的Linux机器上操作。

1. 把hello-1.0.0.jar放到/usr/local/hello目录下，并在该目录下创建Dockerfile文件，内容为：

```Dockerfile
FROM openjdk:8-jdk-alpine
ADD hello-1.0.0.jar /usr/local/hello.jar
ENTRYPOINT ["java", "-jar", "/usr/local/hello.jar"]
```

则/usr/local/hello目录的文件为：

```shell
-rw-r--r-- 1 root root      119 Feb 22 17:50 Dockerfile
-rw-r--r-- 1 root root 21863457 Feb 22 17:07 hello-1.0.0.jar
```

2. 制作镜像，在/usr/local/hello目录下执行命令：

```shell
docker build -t 192.168.109.134:20080/dhorse/hello:1.0.0 .
```

其中，192.168.109.134:20080是Harbor镜像仓库地址，dhorse是项目名。

3. 登录仓库并上传镜像

```shell
docker login 192.168.109.134:20080 -u admin -p Harbor12345
docker push 192.168.109.134:20080/dhorse/hello:1.0.0
```

## 编写Deployment文件

创建hello-k8s.yml文件，内容如下：

```Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
  labels:
    app: hello
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello
        image: 192.168.109.134:20080/dhorse/hello:1.0.0
        imagePullPolicy: Always
```

## 部署应用

以下操作在k8s集群的mater机器上执行。

把hello-k8s.yml文件复制/user/local目录下，并在当前目录执行如下命令：

```shell
kubectl apply -f hello-k8s.yml
```

稍后，再执行如下命令：

```shell
kubectl get pods -o wide
```

输出结果如下：

```shell
NAME                     READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
hello-79d56dc985-7dz6q   1/1     Running   0          8s    10.32.1.180   centos06   <none>           <none>
```

然后在访问/hello接口：

```shell
curl http://10.32.1.180:8080/hello
```

最后，推荐一个部署应用的平台: [https://github.com/512team/dhorse](https://github.com/512team/dhorse)
演示地址：[http://dhorse-demo2.512.team](http://dhorse-demo2.512.team)

