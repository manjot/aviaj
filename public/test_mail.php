<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$mailFile = '/home4/ajathufs/ajath.co.in/mail/class.phpmailer.php';
if (!file_exists($mailFile)) {
    die("PHPMailer not found at " . $mailFile);
}

require_once($mailFile);

echo "<pre>Starting SMTP Test...\n";

$mail = new PHPMailer(true); // Enable exceptions
try {
    $mail->CharSet = "utf-8";
    $mail->IsSMTP();
    $mail->SMTPAuth = true;
    
    // Credentials from user
    $mail->Username = "info@aviaj.com";
    $mail->Password = "P@sssw0rd1111";
    
    // Enable verbose debug output
    $mail->SMTPDebug = 4;
    $mail->Debugoutput = function($str, $level) {
        echo "Level $level: $str\n";
    };

    $mail->SMTPSecure = "ssl";  
    $mail->Host = "ajath.com";
    $mail->Port = "465";
    
    $mail->setFrom('info@aviaj.com', 'Aviaj');
    $mail->AddAddress('manjot@ajath.com', 'Manjot');
    $mail->AddAddress('shachisheh@gmail.com', 'Shachish');
    
    $mail->Subject = "Aviaj SMTP Debug Test";
    $mail->IsHTML(true);
    $mail->Body = "This is a test email with SMTPDebug=4.";
    
    echo "Sending email...\n";
    if ($mail->Send()) {
        echo "Email sent successfully!\n";
    } else {
        echo "Failed to send email.\n";
    }
} catch (Exception $e) {
    echo "PHPMailer Exception: " . $e->getMessage() . "\n";
}
echo "Done.\n</pre>";
