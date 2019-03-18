server {
   listen       80;
   server_name  wanncosmetics-api.ddns.net;

   location / {
       root   /usr/share/nginx/html;
       index  index.html index.htm;
       proxy_pass http://wanncosmetics-api.ddns.net:3000; # to kong api port 8000
   }
}
