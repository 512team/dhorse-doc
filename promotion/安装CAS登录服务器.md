首先，本地具有Java8以上的环境和Tomcat9。

## 下载代码

地址：[https://github.com/apereo/cas-overlay-template/tree/5.3](https://github.com/apereo/cas-overlay-template/tree/5.3)

## 打包

执行命令：

```shell
cd cas-overlay-template-5.3
```

```shell
build package
```

命令执行完以后，会在产生target/cas.war文件。

## 启动服务

1.把cas.war放到tomcat安装目录的webapps文件下，然后启动tomcat服务。

2.访问地址：http://localhost:8080/cas


## 修改登录账号

在tomcat安装目录，打开webapps/cas/WEB-INF/classes/application.properties文件，
cas.authn.accept.users项的值改为：
```
cas.authn.accept.users=admin::admin
```

最后，重启tomcat即可用admin/admin登录cas服务器。