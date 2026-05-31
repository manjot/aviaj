<?php
require_once('/home4/ajathufs/ajath.co.in/mail/class.phpmailer.php');
$mail = new PHPMailer();
$mail->CharSet = "utf-8";
$mail->IsSMTP();
$mail->SMTPAuth = false;
$mail->Host = "localhost";
$mail->Port = "25";
$mail->SMTPDebug  = 2;
$mail->setFrom('info@ajath.ae', 'Ajath UAE');
$mail->AddAddress('manjot@ajath.com', 'Manjot');
$mail->Subject = "Local Relay Test";
$mail->IsHTML(true);
$mail->Body = "This is a test message";
if($mail->Send()) {
    echo "PHPMailer SMTP Relay SUCCESS!\n";
} else {
    echo "PHPMailer SMTP Relay FAILED: " . $mail->ErrorInfo . "\n";
}
