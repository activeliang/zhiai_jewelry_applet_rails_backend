%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
).each { |path| Spring.watch(path) }





server {
  listen       443 ssl http2;
  ssl on;
  ssl_certificate       /etc/nginx/signed.crt;  # 这是跟凭证机构申请后，拿回来的凭证 Key
  ssl_certificate_key    /etc/nginx/domain.key; # 这是一开始我们自己产生的 Private Key

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

  ssl_prefer_server_ciphers on;
  # by https://mozilla.github.io/server-side-tls/ssl-config-generator/
 ssl_ciphers 'ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS';

  server_name www.huiyutongwechat.top huiyutongwechat.top;

  root /home/deploy/huiyu_wechat/current/public;
  passenger_enabled on;

  passenger_min_instances 1;

  location ~ ^/assets/ {
    expires 1y;
    add_header Cache-Control public;
    add_header ETag "";
    break;
  }
}
server {
  listen 80;
  server_name www.huiyutongwechat.top huiyutongwechat.top;
  server_tokens off;
  location / {
    return 301 https://$host$request_uri;
  }
}
