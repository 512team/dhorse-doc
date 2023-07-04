##### 如果没有gcc环境，需要安装gcc

```shell
yum install gcc-c++
```

##### 安装依赖

```shell
yum -y install gcc zlib zlib-devel pcre-devel openssl openssl-devel
```

##### 工作目录

```shell
mkdir /opt/nginx && cd /opt/nginx
```

##### 下载安装包

```shell
wget http://nginx.org/download/nginx-1.32.1.tar.gz
```

##### 解压安装包

```shell
tar -xvf nginx-1.23.1.tar.gz
```

##### 安装目录

```shell
cd nginx-1.23.1
```

##### 安装

```shell
./configure --prefix=/usr/local/nginx --conf-path=/usr/local/nginx/conf/nginx.conf  --error-log-path=/usr/local/nginx/logs/error.log --pid-path=/usr/local/nginx/logs/nginx.pid  --http-log-path=/usr/local/nginx/logs/access.log --with-http_gzip_static_module --with-http_stub_status_module --with-http_ssl_module
```

其中，
#执行命令
#prefix= 指向安装目录（编译安装）
#conf-path= 指向配置文件（nginx.conf）
#error-log-path= 指向错误日志目录
#pid-path= 指向pid文件（nginx.pid）
#http-log-path= 设定access log路径
#with-http_gzip_static_module 启用ngx_http_gzip_static_module支持（在线实时压缩输出数据流）
#with-http_stub_status_module 启用ngx_http_stub_status_module支持（获取nginx自上次启动以来的工作状态）
#with-http_ssl_module 启用ngx_http_ssl_module支持（使支持https请求，需已安装openssl）

##### 执行命令

```shell
make
```

##### 执行make install命令

```shell
make install
```

##### 启动nginx

```shell
 cd  /usr/local/nginx/sbin
./nginx
```

##### 查看nginx进程

```shell
ps -ef | grep nginx
```