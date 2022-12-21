本篇文章介绍用Dockerfile的方式构建Tomcat镜像，请保证安装了Docker环境。

1. 首先创建/opt/tomcat目录，后续步骤都在该目录下进行操作。

2. 准备好Jdk和Tomcat安装文件，放到/opt/tomcat目录下。

3. 编写Dockerfile，内容如下：

```Dockerfile
FROM 192.168.109.134:20080/dhorse/jdk:11.0.16.1

ENV WORKHOME /usr/local
ADD apache-tomcat-9.0.70.tar.gz $WORKHOME
RUN mv $WORKHOME/apache-tomcat-9.0.70 $WORKHOME/tomcat
EXPOSE 8080

CMD $WORKHOME/tomcat/bin/catalina.sh run
```

其中192.168.109.134:20080/dhorse/jdk:11.0.16.1镜像的制作，见[这里]()。

4. /opt/tomcat目下的文件内容如下：

```shell
-rw-r--r-- 1 root root  11613418 Dec 11 20:28 apache-tomcat-9.0.70.tar.gz
-rw-r--r-- 1 root root       479 Dec 12 14:46 Dockerfile
-rw-r--r-- 1 root root 168907175 Dec 11 20:19 jdk-11.0.16.1_linux-x64_bin.tar.gz
```

5. 执行构建命令

```shell
docker build -t 192.168.109.134:20080/dhorse/tomcat:9.0.70-jdk11 .
```

其中，192.168.109.134:20080是镜像仓库地址，如Harbor地址，dhorse是项目名。

6. 登录仓库

```shell
docker login 192.168.109.134:20080 -u admin -p Harbor12345
```

7. 上传镜像

```shell
docker push 192.168.109.134:20080/dhorse/tomcat:9.0.70-jdk11
```

