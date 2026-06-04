<?php
$env = file_get_contents('../.env');
foreach (explode("\n", $env) as $line) {
    if (trim($line) === '' || str_starts_with(trim($line), '#')) {
        continue;
    }
    $parts = explode('=', $line, 2);
    if (count($parts) === 2) {
        $key = $parts[0];
        $val = $parts[1];
        if (str_contains($key, 'PASSWORD') || str_contains($key, 'KEY') || str_contains($key, 'SECRET')) {
            echo "$key = [hidden, length " . strlen($val) . "]\n";
        } else {
            echo "$key = $val\n";
        }
    }
}
