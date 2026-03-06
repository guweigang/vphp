<?php

declare(strict_types=1);

namespace VHttpd;

final class SlimPsr7Adapter
{
    public static function dispatch(VSlim\App $app, object $request): VSlim\Response
    {
        $vRequest = self::toVSlimRequest($request);
        return $app->dispatch_request($vRequest);
    }

    public static function toVSlimRequest(object $request): VSlim\Request
    {
        $method = self::readRequestMethod($request);
        $target = self::readRequestTarget($request);
        $body = self::readBody($request);

        $vRequest = new VSlim\Request($method, $target, $body);
        $vRequest->scheme = self::readUriPart($request, 'getScheme', 'scheme', 'http');
        $vRequest->host = self::readUriPart($request, 'getHost', 'host', '');
        $vRequest->port = self::readUriPart($request, 'getPort', 'port', '');
        $vRequest->protocol_version = self::readProtocolVersion($request);
        $vRequest->remote_addr = self::readServerValue($request, 'REMOTE_ADDR');
        $vRequest->set_headers(self::readHeaders($request));
        $vRequest->set_cookies(self::normalizeMap(self::readMap($request, 'getCookieParams', 'cookies')));
        $vRequest->set_query(self::normalizeMap(self::readMap($request, 'getQueryParams', 'query')));
        $vRequest->set_attributes(self::normalizeMap(self::readAttributes($request)));
        $vRequest->set_server(self::normalizeMap(self::readServerParams($request)));
        $vRequest->set_uploaded_files(self::normalizeList(self::readUploadedFiles($request)));
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

    /** @param array<int,mixed> $items */
    private static function normalizeList(array $items): array
    {
        return array_values(array_map('strval', $items));
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

if (!\class_exists(\VHttpd\VSlimPsr7Adapter::class, false)) {
    \class_alias(\VHttpd\SlimPsr7Adapter::class, \VHttpd\VSlimPsr7Adapter::class);
}
if (!\class_exists('VSlimPsr7Adapter', false)) {
    \class_alias(\VHttpd\SlimPsr7Adapter::class, 'VSlimPsr7Adapter');
}
