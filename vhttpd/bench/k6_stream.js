import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL =
  __ENV.VHTTPD_BASE_URL || __ENV.BASE_URL || "http://127.0.0.1:19881";
const STREAM_PATH =
  __ENV.VHTTPD_STREAM_PATH ||
  __ENV.STREAM_PATH ||
  "/bench/stream?mode=sse&tokens=80&interval_ms=5&chunk_size=24";
const MODE = __ENV.VHTTPD_STREAM_MODE || __ENV.STREAM_MODE || "sse"; // sse | text

export const options = {
  scenarios: {
    stream_requests: {
      executor: "ramping-vus",
      startVUs: 1,
      stages: [
        { duration: "20s", target: 3 },
        { duration: "30s", target: 8 },
        { duration: "20s", target: 3 },
        { duration: "10s", target: 0 },
      ],
      gracefulRampDown: "10s",
    },
  },
  thresholds: {
    http_req_failed: ["rate<0.05"],
    http_req_duration: ["p(95)<15000"],
    checks: ["rate>0.95"],
  },
};

export default function () {
  const res = http.get(`${BASE_URL}${STREAM_PATH}`, {
    timeout: "60s",
    tags: { endpoint: STREAM_PATH, profile: "stream", mode: MODE },
  });

  const body = res.body || "";
  const ok =
    MODE === "sse"
      ? body.includes("event: token") || body.includes("data:")
      : body.length > 0;

  check(res, {
    "status is 200": (r) => r.status === 200,
    "stream has data": () => ok,
  });

  sleep(0.2);
}
