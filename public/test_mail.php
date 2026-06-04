<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$mailFile = '/home4/ajathufs/ajath.co.in/mail/class.phpmailer.php';
if (!file_exists($mailFile)) {
    die("PHPMailer not found at " . $mailFile);
}

require_once($mailFile);

echo "<pre>Starting Multi-SMTP Test...\n";

$configs = [
    [
        'host' => 'mail.aviaj.com',
        'port' => '465',
        'secure' => 'ssl',
        'desc' => 'mail.aviaj.com with SSL'
    ],
    [
        'host' => 'localhost',
        'port' => '25',
        'secure' => '',
        'desc' => 'localhost on port 25 (no SSL)'
    ],
    [
        'host' => 'localhost',
        'port' => '465',
        'secure' => 'ssl',
        'desc' => 'localhost on port 465 (SSL)'
    ],
    [
        'host' => 'ajath.com',
        'port' => '465',
        'secure' => 'ssl',
        'desc' => 'Original: ajath.com with SSL'
    ]
];

foreach ($configs as $idx => $cfg) {
    echo "\n--- Testing Config #$idx: {$cfg['desc']} ({$cfg['host']}:{$cfg['port']}) ---\n";
    $mail = new PHPMailer(true);
    try {
        $mail->CharSet = "utf-8";
        $mail->IsSMTP();
        $mail->SMTPAuth = true;
        $mail->Username = "info@aviaj.com";
        $mail->Password = "P@sssw0rd1111";
        $mail->SMTPSecure = $cfg['secure'];  
        $mail->Host = $cfg['host'];
        $mail->Port = $cfg['port'];
        
        $mail->SMTPDebug = 2; // output debug info
        $mail->Debugoutput = function($str, $level) {
            echo "  [$level] " . trim($str) . "\n";
        };
        
        $mail->setFrom('info@aviaj.com', 'Aviaj');
        $mail->AddAddress('manjot@ajath.com', 'Manjot');
        
        $mail->Subject = "Aviaj Multi-SMTP Test #" . $idx;
        $mail->Body = "Test message for config #" . $idx;
        
        if ($mail->Send()) {
            echo ">>> SUCCESS for config #$idx!\n";
            break; // Stop if we found a working one
        } else {
            echo ">>> FAILED for config #$idx.\n";
        }
    } catch (Exception $e) {
        echo ">>> Exception: " . $e->getMessage() . "\n";
    }
}

echo "\nDone Multi-SMTP Test.\n</pre>";
