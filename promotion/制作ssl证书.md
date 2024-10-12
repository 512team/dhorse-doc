### 安装工具

[参考这里](https://blog.csdn.net/weixin_45602663/article/details/126631496)

### 生成证书

执行如下命令：

```shell
acme.sh --issue --dns dns_ali -d 512.team -d *.512.team --server letsencrypt
```

其中，512.team和*.512.team是你的域名。执行完以上命令以后，会输出证书的路径，如下：

```shell
[Sat Oct 12 20:48:16 CST 2024] Your cert is in: /root/.acme.sh/512.team_ecc/512.team.cer
[Sat Oct 12 20:48:16 CST 2024] Your cert key is in: /root/.acme.sh/512.team_ecc/512.team.key
[Sat Oct 12 20:48:16 CST 2024] The intermediate CA cert is in: /root/.acme.sh/512.team_ecc/ca.cer
[Sat Oct 12 20:48:16 CST 2024] And the full chain certs is there: /root/.acme.sh/512.team_ecc/fullchain.cer
```

其中，fullchain.cer文件是证书的内容，512.team.key文件是证书的秘钥。