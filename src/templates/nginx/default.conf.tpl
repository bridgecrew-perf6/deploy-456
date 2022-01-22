client_header_timeout   300;
client_body_timeout     300;
send_timeout            300;
proxy_connect_timeout   300;
proxy_read_timeout      300;
proxy_send_timeout      300;
server {
<% if (package.ssl) { %>
  listen 443 ssl;
  ssl_certificate      /src/certs/cert.crt;
  ssl_certificate_key  /src/certs/cert.key;
<% } else { %>
  listen 80
<% } %>
  server_name localhost;
  client_max_body_size 20M;
  location / {
    proxy_set_header    Host $host;
    proxy_set_header    X-Real-IP $remote_addr;
    proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header    X-Forwarded-Proto $scheme;
    proxy_pass          https://api-server:3000;
    proxy_read_timeout  300;
    proxy_redirect      https://api-server:3000 https://$host;
  }
<% if (package.pdf) { %>
  location /pdf/ {
    rewrite ^/pdf/(.*)$ /$1 break;
    proxy_set_header    Host $host;
    proxy_set_header    X-Real-IP $remote_addr;
    proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header    X-Forwarded-Proto $scheme;
    proxy_pass          https://pdf-server:4005;
    proxy_read_timeout  300;
    proxy_redirect      https://pdf-server:4005 https://$host;
  }
<% } %>
}