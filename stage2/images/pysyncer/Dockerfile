# ===========================
# Build/Runtime in one stage
# ===========================
FROM localhost:8080/public_mirror/python:3.11

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1

# 必要包：clickhouse-connect 做写入；tzdata 提供时区
RUN sed -i 's|http://deb.debian.org|https://mirrors.aliyun.com|g' /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y --no-install-recommends \
        curl ca-certificates tzdata build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --index-url https://mirrors.aliyun.com/pypi/simple/ clickhouse-connect==0.8.18

WORKDIR /app
COPY main.py /app/main.py

# 默认环境变量（可在 compose/Swarm 覆盖）
ENV LOG_FILE=/data/caddy/logs/web.log \
    CLICKHOUSE_URL=http://clickhouse:8123 \
    CLICKHOUSE_USER=default \
    CLICKHOUSE_PASSWORD=123456 \
    CLICKHOUSE_DATABASE=logs \
    CLICKHOUSE_TABLE=caddy_requests \
    BATCH_SIZE=1000 \
    FLUSH_INTERVAL_SEC=30 \
    TZ="UTC"

CMD ["python", "/app/main.py"]
