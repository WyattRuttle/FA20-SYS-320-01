# Storyline: Send an email

#Body of email
$msg = "Hello there."
#echoing to the screen
write-host -BackgroundColor Red -ForegroundColor white $msg

#Email from Address
$email = "Wyatt.ruttle@mymail.champlain.edu"

#To Address
$toEmail = "deployer@csi-web"
#Sending the email
Send-MailMessage -From $email -to $toEmail -Subject "A Greeting" $msg -SmtpServer 192.168.6.71

