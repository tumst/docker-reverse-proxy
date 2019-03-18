# Docker seperate container: Use this is successful....

## https://medium.com/@prayong/%E0%B9%83%E0%B8%8A%E0%B9%89-docker-%E0%B8%AA%E0%B8%A3%E0%B9%89%E0%B8%B2%E0%B8%87-host-%E0%B8%97%E0%B8%B5%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B8%AB%E0%B8%A5%E0%B8%B2%E0%B8%A2-app-subdomain-ssl-auto-gen-renewal-a856e304a24d
## https://medium.com/@prayong/ใช้-docker-สร้าง-host-ที่มีหลาย-app-subdomain-ssl-auto-gen-renewal-a856e304a24d

1. สั่ง run docker nginx-proxy ก่อนโดยในที่นี้จะต้องเปิด port 80 ไว้สำหรับ http และ port 443 สำหรับ https
```
docker run -d -p 80:80 -p 443:443 --name nginx-proxy \
-v /server/path/certs:/etc/nginx/certs:ro \
-v /etc/nginx/vhost.d \
-v /usr/share/nginx/html \
-v /var/run/docker.sock:/tmp/docker.sock:ro \
jwilder/nginx-proxy
```

2. run letsencrypt-nginx-proxy-companion ครับ (สามารถเปลี่ยนที่อยู่ certs ssl ได้นะครับ แต่ในตัวอย่างนี้จะเก็บไว้ที่ /server/path/certs)
```
docker run -d --name ssl-auto-gen \
-v /server/path/certs:/etc/nginx/certs:rw \
--volumes-from nginx-proxy \
-v /var/run/docker.sock:/var/run/docker.sock:ro \
jrcs/letsencrypt-nginx-proxy-companion
```

3. web site
nginx (ทำ static page) สำหรับ wanncosmetics-api.ddns.net
```
docker run -d --expose 80 --expose 443 \
--name example_container_index \
-v /server/example_index:/usr/share/nginx/html:ro \ 
-e "VIRTUAL_HOST=example.com,www.example.com" \
-e "LETSENCRYPT_HOST=example.com,www.example.com" \
-e "LETSENCRYPT_EMAIL=tumoioio@gmail.com" \
nginx
```

subdomain
```
docker run -d --expose 80 --expose 443 \
--name example_container_tum \
-v "$(pwd)"/server/example_me:/usr/share/nginx/html:ro \
-e "VIRTUAL_HOST=wanncosmetics-api.ddns.net" \
-e "LETSENCRYPT_HOST=wanncosmetics-api.ddns.net" \
-e "LETSENCRYPT_EMAIL=tumoioio@gmail.com" \
nginx
```

## how to use
### by web browser
```
https://wanncosmetics-api.ddns.net
http://wanncosmetics-api.ddns.net
```
### by curl
```
curl wanncosmetics-api.ddns.net
curl https://wanncosmetics-api.ddns.net
```

