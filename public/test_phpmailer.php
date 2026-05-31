<?php
require_once('/home4/ajathufs/ajath.co.in/mail/class.phpmailer.php');
$mail = new PHPMailer();
$mail->CharSet = "utf-8";
$mail->IsSMTP();
$mail->SMTPAuth = true;
$mail->Username = "info@ajath.ae";
$mail->Password = "Ajath@#007!$&";
$mail->SMTPSecure = "tls";  
$mail->Host = "ajath.ae";
$mail->Port = "587";
$mail->SMTPDebug  = 2;
$mail->setFrom('info@ajath.ae', 'Ajath UAE');
$mail->AddAddress('manjot@ajath.com', 'Manjot');
$mail->Subject = "SMTP Test";
$mail->IsHTML(true);
$mail->Body = "This is a test message";
if($mail->Send()) {
    echo "PHPMailer SMTP Authentication SUCCESS!\n";
} else {
    echo "PHPMailer SMTP Authentication FAILED: " . $mail->ErrorInfo . "\n";
}
