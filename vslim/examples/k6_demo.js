import http from "k6/http";
import { check } from "k6";
import { Rate } from "k6/metrics";

const baseUrl = __ENV.BASE_URL || "http://127.0.0.1:19888";
const apiToken = __ENV.API_TOKEN || "demo-token";
const routeMode = (__ENV.ROUTE_MODE || "mixed").toLowerCase();
const serverErrorRate = new Rate("server_error_rate");

// Unauthorized (401) is expected for one route branch in this script.
http.setResponseCallback(http.expectedStatuses(200, 401));

export const options = {
  scenarios: {
    mixed_routes: {
      executor: "ramping-vus",
      startVUs: 0,
      stages: [
        { duration: "10s", target: 10 },
        { duration: "30s", target: 30 },
        { duration: "10s", target: 0 },
      ],
      gracefulRampDown: "5s",
    },
  },
  thresholds: {
    checks: ["rate>0.99"],
    http_req_failed: ["rate<0.01"],
    http_req_duration: ["p(95)<800", "p(99)<1500"],
    server_error_rate: ["rate<0.005"],
  },
};

function hitHealth() {
  const res = http.get(`${baseUrl}/health`, {
    tags: { route: "health" },
  });
  serverErrorRate.add(res.status >= 500, { route: "health" });
  check(res, {
    "health status 200": (r) => r.status === 200,
    "health body ok": (r) => r.body === "OK" || r.body === "ok",
  });
}

function hitHello() {
  const res = http.get(`${baseUrl}/hello/codex?trace_id=k6-demo`, {
    tags: { route: "hello" },
  });
  serverErrorRate.add(res.status >= 500, { route: "hello" });
  check(res, {
    "hello status 200": (r) => r.status === 200,
    "hello has body": (r) => r.body && r.body.length > 0,
    "hello request-id header": (r) => !!r.headers["X-Request-Id"],
  });
}

function hitApiUser() {
  const res = http.get(
    `${baseUrl}/api/users/7?token=${encodeURIComponent(apiToken)}`,
    {
      tags: { route: "api_users" },
    },
  );
  serverErrorRate.add(res.status >= 500, { route: "api_users" });
  check(res, {
    "api users no 5xx": (r) => r.status < 500,
    "api users status 200": (r) => r.status === 200,
    "api users json": (r) => {
      try {
        const data = JSON.parse(r.body);
        return data && data.ok === true;
      } catch (e) {
        return false;
      }
    },
  });
}

function hitUnauthorized() {
  const res = http.get(`${baseUrl}/api/users/7?token=bad-token`, {
    tags: { route: "api_users_unauthorized" },
  });
  serverErrorRate.add(res.status >= 500, { route: "api_users_unauthorized" });
  check(res, {
    "unauthorized status 401": (r) => r.status === 401,
  });
}

function hitFormsEcho() {
  const payload = "name=neo&city=shanghai";
  const res = http.post(`${baseUrl}/forms/echo?token=demo`, payload, {
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    tags: { route: "forms_echo" },
  });
  serverErrorRate.add(res.status >= 500, { route: "forms_echo" });
  check(res, {
    "forms status 200": (r) => r.status === 200,
    "forms json ok": (r) => {
      try {
        const data = JSON.parse(r.body);
        return data && data.ok === true;
      } catch (e) {
        return false;
      }
    },
  });
}

export default function () {
  if (routeMode === "health") {
    hitHealth();
    return;
  }
  if (routeMode === "hello") {
    hitHello();
    return;
  }
  if (routeMode === "api") {
    hitApiUser();
    return;
  }
  if (routeMode === "unauthorized") {
    hitUnauthorized();
    return;
  }
  if (routeMode === "forms") {
    hitFormsEcho();
    return;
  }

  const p = Math.random();
  if (p < 0.35) {
    hitHealth();
  } else if (p < 0.65) {
    hitHello();
  } else if (p < 0.9) {
    hitApiUser();
  } else if (p < 0.95) {
    hitFormsEcho();
  } else {
    hitUnauthorized();
  }
}
