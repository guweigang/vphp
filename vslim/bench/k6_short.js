import http from "k6/http";
import { check, sleep } from "k6";

const BASE_URL = __ENV.BASE_URL || "http://127.0.0.1:19881";
const PATH = __ENV.PATH_UNDER_TEST || "/laravel/hello/guweigang";

export const options = {
  scenarios: {
    short_requests: {
      executor: "ramping-vus",
      startVUs: 1,
      stages: [
        { duration: "20s", target: 10 },
        { duration: "30s", target: 30 },
        { duration: "20s", target: 10 },
        { duration: "10s", target: 0 },
      ],
      gracefulRampDown: "5s",
    },
  },
  thresholds: {
    http_req_failed: ["rate<0.01"],
    http_req_duration: ["p(95)<500", "p(99)<1200"],
    checks: ["rate>0.99"],
  },
};

export default function () {
  const res = http.get(`${BASE_URL}${PATH}`, {
    timeout: "30s",
    tags: { endpoint: PATH, profile: "short" },
  });

  check(res, {
    "status is 200": (r) => r.status === 200,
  });

  // sleep(0.1);
}
