FROM localhost:8080/public_mirror/ubuntu:25.04

COPY source.list /suggested.sources.list

RUN apt update && apt install -y curl

RUN if curl -f http://mirrors.zju.edu.cn/ubuntu/; then \
        echo "Using mirrors.zju.edu.cn" && \
        cp /suggested.sources.list /etc/apt/sources.list && \
        apt update; \
    fi

RUN rm /etc/apt/sources.list.d/ubuntu.sources || true
RUN apt modernize-sources -y && rm /etc/apt/sources.list.bak

RUN apt upgrade -y
