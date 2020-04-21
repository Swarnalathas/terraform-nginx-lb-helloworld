#!/bin/sh

echo "CREATE NGINX CONFIG TEMPLATE"
cat > /tmp/default.conf <<EOF
worker_processes  1;
events {
    worker_connections  1024;
}
 http {
    upstream myproject {
    server aws_instance.server_A weight=1;
    server aws_instance.server_B weight=1;   
  }

  server {
    listen 80;
    
    location / {
      proxy_pass http://myproject;
    }
  }
}
EOF

echo "SET NGINX CONFIG"
sudo mv /tmp/default.conf /etc/nginx/nginx.conf

echo "RESTART NGINX"
sudo systemctl restart nginx


 