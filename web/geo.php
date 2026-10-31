<?php
/**
 * Aviaj Live IP / VPN Geolocation Endpoint (`https://aviaj.com/geo.php`)
 * Detects visitor's real or VPN country code from IP address so VPN switches
 * (e.g. Turbo VPN set to USA, Middle East, Europe, India, APAC) immediately
 * serve region-matched imagery and profiles.
 */
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');

function getVisitorIp(): string {
    $candidates = [
        'HTTP_CF_CONNECTING_IP',
        'HTTP_X_REAL_IP',
        'HTTP_X_FORWARDED_FOR',
        'HTTP_CLIENT_IP',
        'REMOTE_ADDR',
    ];
    foreach ($candidates as $key) {
        if (!empty($_SERVER[$key])) {
            $raw = explode(',', (string)$_SERVER[$key])[0];
            $ip = trim($raw);
            if (filter_var($ip, FILTER_VALIDATE_IP)) {
                return $ip;
            }
        }
    }
    return $_SERVER['REMOTE_ADDR'] ?? '127.0.0.1';
}

$ip = getVisitorIp();
$countryCode = '';

// 1. Check Cloudflare header if present
if (!empty($_SERVER['HTTP_CF_IPCOUNTRY']) && $_SERVER['HTTP_CF_IPCOUNTRY'] !== 'XX') {
    $countryCode = strtoupper(trim((string)$_SERVER['HTTP_CF_IPCOUNTRY']));
}

// 2. Query api.country.is/{ip}
if (empty($countryCode)) {
    $ch = curl_init('https://api.country.is/' . urlencode($ip));
    if ($ch !== false) {
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 3,
            CURLOPT_CONNECTTIMEOUT => 2,
            CURLOPT_USERAGENT => 'AviajGeo/1.0',
        ]);
        $resp = curl_exec($ch);
        curl_close($ch);
        if (is_string($resp)) {
            $data = json_decode($resp, true);
            if (!empty($data['country'])) {
                $countryCode = strtoupper(trim((string)$data['country']));
            }
        }
    }
}

// 3. Fallback to ip-api.com
if (empty($countryCode)) {
    $ch = curl_init('http://ip-api.com/json/' . urlencode($ip) . '?fields=status,countryCode');
    if ($ch !== false) {
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 3,
            CURLOPT_CONNECTTIMEOUT => 2,
            CURLOPT_USERAGENT => 'AviajGeo/1.0',
        ]);
        $resp = curl_exec($ch);
        curl_close($ch);
        if (is_string($resp)) {
            $data = json_decode($resp, true);
            if (!empty($data['countryCode'])) {
                $countryCode = strtoupper(trim((string)$data['countryCode']));
            }
        }
    }
}

echo json_encode([
    'ip' => $ip,
    'country' => $countryCode ?: 'US',
    'timestamp' => time(),
]);

