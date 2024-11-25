# Nginx 기반의 Flutter 웹 앱 이미지 생성
FROM nginx:alpine

# Nginx 기본 설정을 사용하며, 빌드된 Flutter 파일을 복사
COPY ./web /usr/share/nginx/html

# 컨테이너가 80번 포트로 동작
EXPOSE 80

# Nginx 실행 명령
CMD ["nginx", "-g", "daemon off;"]
