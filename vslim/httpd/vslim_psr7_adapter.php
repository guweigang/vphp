<?php

declare(strict_types=1);

final class VSlimPsr7Adapter
{
    public static function dispatch(VSlimApp $app, object $request): VSlimResponse
    {
        $vRequest = self::toVSlimRequest($request);
        return $app->dispatch_request($vRequest);
    }

    public static function toVSlimRequest(object $request): VSlimRequest
    {
        $method = self::readRequestMethod($request);
        $target = self::readRequestTarget($request);
        $body = self::readBody($request);

        $vRequest = new VSlimRequest($method, $target, $body);
        $vRequest->scheme = self::readUriPart($request, 'getScheme', 'scheme', 'http');
        $vRequest->host = self::readUriPart($request, 'getHost', 'host', '');
        $vRequest->port = self::readUriPart($request, 'getPort', 'port', '');
        $vRequest->protocol_version = self::readProtocolVersion($request);
        $vRequest->remote_addr = self::readServerValue($request, 'REMOTE_ADDR');
        $vRequest->headers_json = json_encode(self::readHeaders($request), JSON_UNESCAPED_UNICODE);
        $vRequest->cookies_json = json_encode(self::readMap($request, 'getCookieParams', 'cookies'), JSON_UNESCAPED_UNICODE);
        $vRequest->query_json = json_encode(self::readMap($request, 'getQueryParams', 'query'), JSON_UNESCAPED_UNICODE);
        $vRequest->attributes_json = json_encode(self::readAttributes($request), JSON_UNESCAPED_UNICODE);
        $vRequest->server_json = json_encode(self::readServerParams($request), JSON_UNESCAPED_UNICODE);
        $vRequest->uploaded_files_json = json_encode(self::readUploadedFiles($request), JSON_UNESCAPED_UNICODE);
        return $vRequest;
    }

    /** @return array<string,mixed> */
    public static function toWorkerEnvelope(object $request): array
    {
        $vRequest = self::toVSlimRequest($request);
        return [
            'method' => $vRequest->method,
            'path' => $vRequest->raw_path,
            'body' => $vRequest->body,
            'scheme' => $vRequest->scheme,
            'host' => $vRequest->host,
            'port' => $vRequest->port,
            'protocol_version' => $vRequest->protocol_version,
            'remote_addr' => $vRequest->remote_addr,
            'headers' => self::readHeaders($request),
            'cookies' => self::normalizeMap(self::readMap($request, 'getCookieParams', 'cookies')),
            'query' => self::normalizeMap(self::readMap($request, 'getQueryParams', 'query')),
            'attributes' => self::normalizeMap(self::readAttributes($request)),
            'server' => self::normalizeMap(self::readServerParams($request)),
            'uploaded_files' => self::readUploadedFiles($request),
            // Keep compatibility with current exported vslim_handle_request envelope shape.
            'headers_json' => $vRequest->headers_json,
            'cookies_json' => $vRequest->cookies_json,
            'query_json' => $vRequest->query_json,
            'attributes_json' => $vRequest->attributes_json,
            'server_json' => $vRequest->server_json,
            'uploaded_files_json' => $vRequest->uploaded_files_json,
        ];
    }

    private static function readRequestMethod(object $request): string
    {
        return self::readString($request, 'getMethod', 'method', 'GET');
    }

    private static function readRequestTarget(object $request): string
    {
        if (method_exists($request, 'getRequestTarget')) {
            return (string)$request->getRequestTarget();
        }
        $uri = self::readUriObject($request);
        if (is_object($uri)) {
            if (method_exists($uri, 'getPath')) {
                $path = (string)$uri->getPath();
                $query = method_exists($uri, 'getQuery') ? (string)$uri->getQuery() : '';
                return $query !== '' ? $path . '?' . $query : $path;
            }
            if (property_exists($uri, 'path')) {
                $path = (string)$uri->path;
                $query = property_exists($uri, 'query') ? (string)$uri->query : '';
                return $query !== '' ? $path . '?' . $query : $path;
            }
        }
        if (property_exists($request, 'uri')) {
            $uriValue = $request->uri;
            if (is_string($uriValue)) {
                $parts = parse_url($uriValue);
                $path = (string)($parts['path'] ?? '/');
                $query = (string)($parts['query'] ?? '');
                return $query !== '' ? $path . '?' . $query : $path;
            }
        }
        return '/';
    }

    private static function readBody(object $request): string
    {
        if (method_exists($request, 'getBody')) {
            return (string)$request->getBody();
        }
        if (property_exists($request, 'body')) {
            return (string)$request->body;
        }
        return '';
    }

    private static function readProtocolVersion(object $request): string
    {
        return self::readString($request, 'getProtocolVersion', 'protocolVersion', '1.1');
    }

    /** @return array<string,string> */
    private static function readHeaders(object $request): array
    {
        $raw = [];
        if (method_exists($request, 'getHeaders')) {
            $raw = (array)$request->getHeaders();
        } elseif (property_exists($request, 'headers') && is_array($request->headers)) {
            $raw = $request->headers;
        }
        $headers = [];
        foreach ($raw as $name => $value) {
            if (is_array($value)) {
                $headers[strtolower((string)$name)] = implode(', ', array_map('strval', $value));
            } else {
                $headers[strtolower((string)$name)] = (string)$value;
            }
        }
        return $headers;
    }

    /** @return array<string,mixed> */
    private static function readAttributes(object $request): array
    {
        if (method_exists($request, 'getAttributes')) {
            return (array)$request->getAttributes();
        }
        if (property_exists($request, 'attributes') && is_array($request->attributes)) {
            return $request->attributes;
        }
        return [];
    }

    /** @return array<string,mixed> */
    private static function readServerParams(object $request): array
    {
        if (method_exists($request, 'getServerParams')) {
            return (array)$request->getServerParams();
        }
        if (property_exists($request, 'server') && is_array($request->server)) {
            return $request->server;
        }
        return [];
    }

    /** @return array<int,mixed> */
    private static function readUploadedFiles(object $request): array
    {
        if (method_exists($request, 'getUploadedFiles')) {
            return array_values((array)$request->getUploadedFiles());
        }
        if (property_exists($request, 'uploadedFiles') && is_array($request->uploadedFiles)) {
            return array_values($request->uploadedFiles);
        }
        return [];
    }

    /** @return array<string,mixed> */
    private static function readMap(object $request, string $getter, string $property): array
    {
        if (method_exists($request, $getter)) {
            return (array)$request->{$getter}();
        }
        if (property_exists($request, $property) && is_array($request->{$property})) {
            return $request->{$property};
        }
        return [];
    }

    /** @param array<string,mixed> $map */
    private static function normalizeMap(array $map): array
    {
        $out = [];
        foreach ($map as $key => $value) {
            if (!is_string($key)) {
                continue;
            }
            if (is_array($value)) {
                $out[$key] = implode(', ', array_map('strval', $value));
            } else {
                $out[$key] = (string) $value;
            }
        }
        return $out;
    }

    private static function readServerValue(object $request, string $key): string
    {
        $server = self::readServerParams($request);
        return isset($server[$key]) ? (string)$server[$key] : '';
    }

    private static function readUriPart(object $request, string $getter, string $property, string $default): string
    {
        $uri = self::readUriObject($request);
        if (is_object($uri)) {
            if (method_exists($uri, $getter)) {
                $value = $uri->{$getter}();
                return $value === null ? $default : (string)$value;
            }
            if (property_exists($uri, $property)) {
                $value = $uri->{$property};
                return $value === null ? $default : (string)$value;
            }
        }
        if (property_exists($request, 'uri') && is_string($request->uri)) {
            $parts = parse_url($request->uri);
            return match ($property) {
                'scheme' => (string)($parts['scheme'] ?? $default),
                'host' => (string)($parts['host'] ?? $default),
                'port' => isset($parts['port']) ? (string)$parts['port'] : $default,
                default => $default,
            };
        }
        return $default;
    }

    private static function readUriObject(object $request): ?object
    {
        if (method_exists($request, 'getUri')) {
            $uri = $request->getUri();
            return is_object($uri) ? $uri : null;
        }
        if (property_exists($request, 'uri') && is_object($request->uri)) {
            return $request->uri;
        }
        return null;
    }

    private static function readString(object $request, string $getter, string $property, string $default): string
    {
        if (method_exists($request, $getter)) {
            return (string)$request->{$getter}();
        }
        if (property_exists($request, $property)) {
            return (string)$request->{$property};
        }
        return $default;
    }
}
