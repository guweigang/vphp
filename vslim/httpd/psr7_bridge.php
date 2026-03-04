<?php

declare(strict_types=1);

final class VHttpdPsr7Bridge
{
    public static function canBuildServerRequest(): bool
    {
        return self::detectFactoryKind() !== null;
    }

    /**
     * @param array<string,mixed> $envelope
     * @return object|null
     */
    public static function buildServerRequest(array $envelope): ?object
    {
        $kind = self::detectFactoryKind();
        if ($kind === null) {
            return null;
        }

        $method = strtoupper((string)($envelope['method'] ?? 'GET'));
        $path = (string)($envelope['path'] ?? '/');
        $body = (string)($envelope['body'] ?? '');
        $scheme = (string)($envelope['scheme'] ?? 'http');
        $host = (string)($envelope['host'] ?? '');
        $port = (string)($envelope['port'] ?? '');
        $protocolVersion = (string)($envelope['protocol_version'] ?? '1.1');
        $remoteAddr = (string)($envelope['remote_addr'] ?? '');
        $headers = self::decodeNameMap((string)($envelope['headers_json'] ?? '{}'));
        $cookies = self::decodeNameMap((string)($envelope['cookies_json'] ?? '{}'));
        $query = self::decodeNameMap((string)($envelope['query_json'] ?? '{}'));
        $attributes = self::decodeNameMap((string)($envelope['attributes_json'] ?? '{}'));
        $server = self::decodeNameMap((string)($envelope['server_json'] ?? '{}'));
        $uploadedFiles = self::decodeUploadedFiles((string)($envelope['uploaded_files_json'] ?? '[]'));

        if ($query === []) {
            $query = self::parseQueryFromPath($path);
        }

        $uri = self::buildUri($path, $scheme, $host, $port);
        $server = self::mergeServerParams($server, $method, $path, $scheme, $host, $port, $remoteAddr, $protocolVersion, $headers);

        return match ($kind) {
            'nyholm' => self::buildWithNyholm($method, $uri, $server, $headers, $cookies, $query, $body, $attributes, $uploadedFiles, $protocolVersion),
            'guzzle' => self::buildWithGuzzle($method, $uri, $server, $headers, $cookies, $query, $body, $attributes, $uploadedFiles, $protocolVersion),
            default => null,
        };
    }

    private static function detectFactoryKind(): ?string
    {
        if (class_exists('Nyholm\\Psr7\\Factory\\Psr17Factory')) {
            return 'nyholm';
        }
        if (class_exists('GuzzleHttp\\Psr7\\HttpFactory')) {
            return 'guzzle';
        }
        return null;
    }

    /**
     * @param array<string,string> $server
     * @param array<string,string> $headers
     * @return array<string,string>
     */
    private static function mergeServerParams(array $server, string $method, string $path, string $scheme, string $host, string $port, string $remoteAddr, string $protocolVersion, array $headers): array
    {
        $merged = $server;
        $merged['REQUEST_METHOD'] = $method;
        $merged['REQUEST_URI'] = $path;
        $merged['SERVER_PROTOCOL'] = 'HTTP/' . $protocolVersion;
        if ($host !== '') {
            $merged['HTTP_HOST'] = $host;
            $merged['SERVER_NAME'] = $host;
        }
        if ($port !== '') {
            $merged['SERVER_PORT'] = $port;
        }
        if ($remoteAddr !== '') {
            $merged['REMOTE_ADDR'] = $remoteAddr;
        }
        $merged['HTTPS'] = $scheme === 'https' ? 'on' : 'off';
        foreach ($headers as $name => $value) {
            $key = 'HTTP_' . strtoupper(str_replace('-', '_', $name));
            $merged[$key] = $value;
        }
        return $merged;
    }

    /** @return array<string,string> */
    private static function decodeNameMap(string $json): array
    {
        if ($json === '') {
            return [];
        }
        $decoded = json_decode($json, true);
        if (!is_array($decoded)) {
            return [];
        }
        $out = [];
        foreach ($decoded as $key => $value) {
            if (is_string($key) && (is_scalar($value) || $value === null)) {
                $out[$key] = (string)$value;
            }
        }
        return $out;
    }

    /** @return array<int,mixed> */
    private static function decodeUploadedFiles(string $json): array
    {
        $decoded = json_decode($json, true);
        return is_array($decoded) ? $decoded : [];
    }

    /** @return array<string,string> */
    private static function parseQueryFromPath(string $path): array
    {
        $query = parse_url($path, PHP_URL_QUERY);
        if (!is_string($query) || $query === '') {
            return [];
        }
        parse_str($query, $parsed);
        $out = [];
        foreach ($parsed as $key => $value) {
            if (is_string($key) && (is_scalar($value) || $value === null)) {
                $out[$key] = (string)$value;
            }
        }
        return $out;
    }

    private static function buildUri(string $path, string $scheme, string $host, string $port): string
    {
        if ($host === '') {
            return $path;
        }
        $authority = $host;
        if ($port !== '') {
            $authority .= ':' . $port;
        }
        if (str_starts_with($path, '/')) {
            return $scheme . '://' . $authority . $path;
        }
        return $scheme . '://' . $authority . '/' . $path;
    }

    /**
     * @param array<string,string> $server
     * @param array<string,string> $headers
     * @param array<string,string> $cookies
     * @param array<string,string> $query
     * @param array<string,string> $attributes
     * @param array<int,mixed> $uploadedFiles
     */
    private static function buildWithNyholm(string $method, string $uri, array $server, array $headers, array $cookies, array $query, string $body, array $attributes, array $uploadedFiles, string $protocolVersion): object
    {
        $factory = new \Nyholm\Psr7\Factory\Psr17Factory();
        $request = $factory->createServerRequest($method, $uri, $server);
        $request = $request->withProtocolVersion($protocolVersion);
        $request = $request->withBody($factory->createStream($body));
        $request = $request->withCookieParams($cookies);
        $request = $request->withQueryParams($query);
        $request = $request->withUploadedFiles($uploadedFiles);
        foreach ($headers as $name => $value) {
            $request = $request->withHeader($name, $value);
        }
        foreach ($attributes as $name => $value) {
            $request = $request->withAttribute($name, $value);
        }
        return $request;
    }

    /**
     * @param array<string,string> $server
     * @param array<string,string> $headers
     * @param array<string,string> $cookies
     * @param array<string,string> $query
     * @param array<string,string> $attributes
     * @param array<int,mixed> $uploadedFiles
     */
    private static function buildWithGuzzle(string $method, string $uri, array $server, array $headers, array $cookies, array $query, string $body, array $attributes, array $uploadedFiles, string $protocolVersion): object
    {
        $factory = new \GuzzleHttp\Psr7\HttpFactory();
        $request = $factory->createServerRequest($method, $uri, $server);
        $request = $request->withProtocolVersion($protocolVersion);
        $request = $request->withBody($factory->createStream($body));
        $request = $request->withCookieParams($cookies);
        $request = $request->withQueryParams($query);
        $request = $request->withUploadedFiles($uploadedFiles);
        foreach ($headers as $name => $value) {
            $request = $request->withHeader($name, $value);
        }
        foreach ($attributes as $name => $value) {
            $request = $request->withAttribute($name, $value);
        }
        return $request;
    }
}
