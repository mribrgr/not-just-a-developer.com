FROM ghcr.io/getzola/zola:v0.20.0 AS zola

COPY . /project
WORKDIR /project
RUN ["zola", "build"]

FROM nginx:alpine
WORKDIR /

COPY --from=zola /project/public /usr/share/nginx/html
