以下步骤在具有Docker环境的Linux机器上操作。

1. 把springboot-1.0.0.jar放到/usr/local/springboot目录下，并在该目录下创建Dockerfile文件，内容为：

```Dockerfile
FROM openjdk:8-jdk-alpine
ADD springboot-1.0.0.jar /usr/local/springboot.jar
ENTRYPOINT ["java", "-jar", "/usr/local/springboot.jar"]
```

则/usr/local/springboot目录的文件为：

```shell
-rw-r--r-- 1 root root      119 Feb 22 17:50 Dockerfile
-rw-r--r-- 1 root root 21863457 Feb 22 17:07 springboot-1.0.0.jar
```

2. 制作镜像，在/usr/local/springboot目录下执行命令：

```shell
docker build -t 192.0.10.22:20080/dhorse/springboot:1.0.0 .
```

其中，192.0.10.22:20080是Harbor镜像仓库地址，dhorse是项目名。

3. 登录仓库并上传镜像

```shell
docker login 192.0.10.22:20080 -u admin -p Harbor12345
docker push 192.0.10.22:20080/dhorse/springboot:1.0.0
```

最后，推荐一个不错的部署应用的工具，DHorse([https://github.com/512team/dhorse](https://github.com/512team/dhorse))