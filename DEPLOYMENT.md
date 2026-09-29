# Thông Tin Deploy — Checkpoint 5

> Điền file này sau khi deploy xong. `pytest tests/test_cp5.py` đọc file này
> để tìm địa chỉ service của bạn và gọi thử.
>
> **Chỉ ghi TÊN biến môi trường, tuyệt đối không dán giá trị API key vào đây.**
> Repo này công khai — dán khóa vào là mất khóa.

## Thông Tin Học Viên

| Mục         | Nội dung                                                                                                   |
| ----------- | ---------------------------------------------------------------------------------------------------------- |
| Họ và tên   | Trần Quốc Toản                                                                                             |
| Mã học viên | 2A202602984                                                                                                |
| Repo        | https://github.com/tranquoctoan2004/K4-L3B-DAY12-TranQuocToan-2A202602984-Cloud-Service-And-Deployment.git |

## Service

| Mục         | Nội dung                              |
| ----------- | ------------------------------------- |
| Public URL  | https://day12-agent-geva.onrender.com |
| Platform    | Render                                |
| Ngày deploy | 2026-09-29                            |

## Biến Môi Trường Đã Set Trên Cloud

Ghi tên biến và **nguồn giá trị**, không ghi giá trị:

| Biến                    | Đã set | Ghi chú                                   |
| ----------------------- | ------ | ----------------------------------------- |
| `PORT`                  | ✅     | platform tự gán                           |
| `AGENT_API_KEY`         | ✅     | đặt trong dashboard, không nằm trong repo |
| `REDIS_URL`             | ✅     | Render Key Value / Redis add-on           |
| `RATE_LIMIT_PER_MINUTE` | ✅     | 10                                        |
| `MONTHLY_BUDGET_USD`    | ✅     | 10.0                                      |
| `LOG_LEVEL`             | ✅     | INFO                                      |

## Lệnh Kiểm Tra

Thay `<URL>` bằng Public URL ở trên:

```bash
# 1. Liveness — mong đợi 200 {"status":"ok"}
curl -i [https://day12-agent-geva.onrender.com/health](https://day12-agent-geva.onrender.com/health)

# 2. Readiness — mong đợi 200 {"status":"ready"} (đã nối được Redis)
curl -i [https://day12-agent-geva.onrender.com/ready](https://day12-agent-geva.onrender.com/ready)

# 3. Không có API key — mong đợi 401
curl -i -X POST [https://day12-agent-geva.onrender.com/ask](https://day12-agent-geva.onrender.com/ask) \
  -H "Content-Type: application/json" \
  -d '{"question":"Hello"}'

# 4. Có API key — mong đợi 200 kèm câu trả lời
curl -i -X POST [https://day12-agent-geva.onrender.com/ask](https://day12-agent-geva.onrender.com/ask) \
  -H "Content-Type: application/json" \
  -H "X-API-Key: $AGENT_API_KEY" \
  -H "X-User-Id: sv-test" \
  -d '{"question":"Deploy là gì?"}'

# 5. Rate limit — gọi 15 lần, những lần cuối phải trả 429
for i in $(seq 1 15); do
  curl -s -o /dev/null -w "%{http_code} " -X POST [https://day12-agent-geva.onrender.com/ask](https://day12-agent-geva.onrender.com/ask) \
    -H "Content-Type: application/json" \
    -H "X-API-Key: $AGENT_API_KEY" \
    -H "X-User-Id: sv-test" \
    -d '{"question":"test"}'
done; echo
```
