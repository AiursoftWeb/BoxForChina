FROM localhost:8080/public_mirror/ubuntu:25.10

COPY source.list /suggested.sources.list

RUN apt update && apt install -y curl

RUN if curl -f http://ftp.sjtu.edu.cn/ubuntu/; then \
        echo "Using ftp.sjtu.edu.cn" && \
        rm /etc/apt/sources.list.d/ubuntu.sources && \
        cp /suggested.sources.list /etc/apt/sources.list && \
        apt update; \
    fi

RUN apt modernize-sources -y && rm /etc/apt/sources.list.bak

RUN apt upgrade -y
