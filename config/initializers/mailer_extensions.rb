class ActionMailer::Base
    
  def self.configure_for_site(site_id)    
    settings = Caboose::SmtpConfig.where(:site_id => site_id).first
    self.delivery_method = :smtp
    self.default(:from => settings.from_address)    
    self.smtp_settings = {
      :user_name            => settings.user_name, 
      :password             => settings.password,
      :address              => settings.address,
      :port                 => settings.port,
      :domain               => settings.domain,
      :authentication       => settings.authentication,
      :enable_starttls_auto => settings.enable_starttls_auto,
      :from                 => settings.from_address,
      :reply_to             => settings.reply_to_address
    }                    
    return self
  end

end
