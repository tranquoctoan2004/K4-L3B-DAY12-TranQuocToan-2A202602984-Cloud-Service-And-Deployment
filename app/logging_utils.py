"""CP1 — Structured logging."""

from __future__ import annotations

import json
import sys
from datetime import datetime, timezone


def utc_now_iso() -> str:
    """CHO SẴN — thời điểm hiện tại theo ISO-8601, múi giờ UTC."""
    return datetime.now(timezone.utc).isoformat()


def log_event(event: str, level: str = "info", **fields) -> str:
    """Ghi một dòng log JSON ra stdout."""
    log_dict = {
        "event": event,
        "level": level.lower(),
        "timestamp": utc_now_iso(),
    }
    log_dict.update(fields)

    # In JSON 1 dòng duy nhất ra stdout, không dùng indent, đảm bảo hỗ trợ tiếng Việt UTF-8
    log_line = json.dumps(log_dict, ensure_ascii=False)
    print(log_line, file=sys.stdout, flush=True)
    return log_line