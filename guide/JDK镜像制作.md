本文介绍用Dockerfile的方式构建Jdk镜像，请保证安装了Docker环境。

1. 首先创建/opt/jdk目录，后续步骤都在该目录下进行操作。

2. 准备好Jdk安装文件，放到/opt/jdk目录下。

3. 编写Dockerfile，内容如下：

```Dockerfile
FROM centos:latest

ENV WORKHOME /usr/local
ADD jdk-11.0.16.1_linux-x64_bin.tar.gz $WORKHOME
ENV JAVA_HOME $WORKHOME/jdk-11.0.16.1
ENV PATH $JAVA_HOME/bin:$PATH
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

4. /opt/jdk目下的文件内容如下：

```shell
-rw-r--r-- 1 root root       221 Dec 14 20:29 Dockerfile
-rw-r--r-- 1 root root 168907175 Sep 23 16:24 jdk-11.0.16.1_linux-x64_bin.tar.gz
```

5. 执行构建命令

```shell
docker build -t 192.168.109.134:20080/dhorse/jdk:11.0.16.1 .
```

其中，192.168.109.134:20080是镜像仓库地址，如Harbor地址，dhorse是项目名，必须要按照以上格式定义镜像的名称

6. 登录仓库

```shell
docker login 192.168.109.134:20080 -u admin -p Harbor12345
```

7. 上传镜像

```shell
docker push 192.168.109.134:20080/dhorse/jdk:11.0.16.1
```

