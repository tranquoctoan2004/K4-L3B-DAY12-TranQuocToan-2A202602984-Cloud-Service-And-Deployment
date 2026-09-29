# Stage 1: Builder
FROM python:3.11-slim AS builder

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Copy requirements và cài đặt thư viện trước để tối ưu layer cache
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim AS runtime

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=8000

# Copy thư viện đã build từ stage builder
COPY --from=builder /install /usr/local

# Copy nguồn ứng dụng
COPY app/ ./app/
COPY utils/ ./utils/

# Tạo và chuyển sang user thường (non-root) để bảo mật
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app
USER appuser

# Thêm Healthcheck gọi đến endpoint /health
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:' + str(${PORT:-8000}) + '/health')" || exit 1

EXPOSE 8000

# Bind Uvicorn vào 0.0.0.0 và đọc cổng linh hoạt từ biến môi trường PORT
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]