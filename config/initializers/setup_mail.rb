ActionMailer::Base.smtp_settings = {
  :address				=> "smtp.gmail.com",
  :port					=> 587,
  :domain				=> "ombtraining",
  :user_name			=> "nicolasradu16",
  :password				=> "motdepasse",
  :authentication		=> "plain",
  :enable_starttls_auto	=> true
}