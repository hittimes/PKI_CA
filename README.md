# PKI_CA 基于 Ubuntu 自建三级CA架构

## 1. 下载脚本
root 用户登录 <br>
``` shell
cd /root/
git clone https://github.com/hittimes/PKI_CA.git
cd PKI_CA/tools

chmod +x gen*.sh
```


## 2. 创建 根CA

``` shell
cd /root/PKI_CA/tools

./gen-root-ca.sh

# 按提示输入CA 信息


```

## 2. 创建 二级CA（WEB SSL CA）

``` shell
cd /root/PKI_CA/tools

./gen-ssl-ca.sh

# 按提示输入CA 信息


```


## 3. 创建 用户证书（WEB SSL Cert）

``` shell
cd /root/PKI_CA/tools

# 在 domains.txt 中修改服务器域名信息
[ alt_names ]
DNS.1=example.com
DNS.2=www.example.com

# ./gen-server-cert.sh 证书文件名 证书CommonName（CN）
./gen-server-cert.sh myweb www.example.com

# 按提示输入证书信息
# 按提示输入SSL CA 私钥密码，用于签发用户证书

# 签发好的证书保存在 /root/ssl_ca/output

```