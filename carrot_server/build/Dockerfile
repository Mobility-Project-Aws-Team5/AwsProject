# frontend/Dockerfile
FROM nginx:latest

# 빌드된 파일을 Nginx 기본 HTML 위치에 복사
COPY . /usr/share/nginx/html

# Nginx 기본 포트 노출
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
