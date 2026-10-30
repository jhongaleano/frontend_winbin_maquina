
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app
COPY . .

ARG API_URL
ARG IA_URL
ARG WS_URL


RUN flutter pub get
RUN flutter build web --release \
                    --dart-define=API_URL=${API_URL} \
                    --dart-define=IA_URL=${IA_URL} \
                    --dart-define=WS_URL=${WS_URL} 


FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]