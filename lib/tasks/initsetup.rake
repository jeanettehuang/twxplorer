task :loadtweetdb do

  ENV["RAILS_ENV"] ||= "development"

  require File.dirname(__FILE__) + "/../../config/application"
  Rails.application.require_environment!

    TweetStream.configure do |config|
      config.consumer_key       = 'QaMI7yj4FDxMPaFLTylx3w'
      config.consumer_secret    = 'SFeKrXMdONjVwtTAmSqWzsgV67gOBDYiDiij6oMqOw'
      config.oauth_token        = '54643263-c3D4hlanTeUr5u69wV5KtadwYNtvaTBgQAneIoIAD'
      config.oauth_token_secret = 'eHyhAeJ6LzbFaaCuRyyniZTepxiUjmElkk3R7YllCek'
      config.auth_method        = :oauth
    end

    TweetStream::Client.new.sample do |status|
      begin
        if status.user.lang == "en"
         Tweet.create!({
          :text => status.text,
          :username => status.user.screen_name,
          :created_at => status.created_at,
          :lang => status.user.lang,
          :time_zone => status.user.time_zone,
          :guid => status[:id]
          })
         puts "[#{status.user.screen_name}] #{status.text}"
        end
      rescue
       puts "Couldnt insert tweet. Possibly db lock error"
      end
    end

end
