#!/bin/sh

echo "CREATE NGINX CONFIG TEMPLATE"
cat > /tmp/default.conf <<EOF
worker_processes  1;
events {
    worker_connections  1024;
}
 http {
    upstream myproject {
    server ec2-3-8-122-233.eu-west-2.compute.amazonaws.com weight=1;
    server ec2-35-177-216-167.eu-west-2.compute.amazonaws.com weight=1;   
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


 