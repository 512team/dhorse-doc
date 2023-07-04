## 通过docker安装

```shell
sudo docker run \

-p 389:389\

-p 636:636\

--name youe_ldap\

--network bridge\

--hostname openldap-host\

--env LDAP_ORGANISATION="youedata"\

--env LDAP_DOMAIN="youedata.com"\

--env LDAP_ADMIN_PASSWORD="youedata520" \

--detach osixia/openldap
```

其中，

配置LDAP组织者：--env LDAP_ORGANISATION="youedata"

配置LDAP域：--env LDAP_DOMAIN="youedata.com"

配置LDAP密码：--env LDAP_ADMIN_PASSWORD="youedata520"

默认登录用户名：admin


## windows环境安装

1.下载安装包：[https://www.maxcrc.de/en/download-en](https://www.maxcrc.de/en/download-en)

2.双击安装文件，直接进行傻瓜式安装

3.在安装目录中，打开slapd.conf文件，找到管理员账号，

```
rootdn		"cn=Manager,dc=maxcrc,dc=com"
```

默认密码是：secret。

## 安装phpLdapAdmin

```shell
docker run \

-d --privileged \

-p 18004:80 \

--name you_pla \

--env PHPLDAPADMIN_HTTPS=false \

--env PHPLDAPADMIN_LDAP_HOSTS=192.168.1.169 \

--detach osixia/phpldapadmin

```

PHPLDAPADMIN_LDAP_HOSTS更改为LDAP服务器的IP，然后访问IP:18004端口，出现登录界面，表示安装成功，最后使用Ldap服务器的管理员登录即可。