FROM scratch AS s
ADD alpine.tar.gz /
WORKDIR /usr/app
ARG VERSION="1.0.0"
RUN echo '#!/bin/sh' > sk.sh && \
    echo 'hostname -i' >> sk.sh && \
    echo 'hostname' >> sk.sh && \
    echo "echo '$VERSION'" >> sk.sh && \
    chmod +x sk.sh

FROM nginx
WORKDIR /usr/share/nginx/html
COPY --from=s /usr/app/sk.sh .
RUN ./sk.sh > index.html
EXPOSE 80
HEALTHCHECK --interval=10s --timeout=1s \
    CMD curl -f http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
