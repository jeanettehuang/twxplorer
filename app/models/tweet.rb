class Tweet < ActiveRecord::Base
  attr_accessible :created_at, :guid, :lang, :text, :time_zone, :username

  def self.get_tweets
    TweetStream.configure do |config|
      config.consumer_key       = 'QaMI7yj4FDxMPaFLTylx3w'
      config.consumer_secret    = 'SFeKrXMdONjVwtTAmSqWzsgV67gOBDYiDiij6oMqOw'
      config.oauth_token        = '54643263-c3D4hlanTeUr5u69wV5KtadwYNtvaTBgQAneIoIAD'
      config.oauth_token_secret = 'eHyhAeJ6LzbFaaCuRyyniZTepxiUjmElkk3R7YllCek'
      config.auth_method        = :oauth
    end

    @tweetcount = 0
    TweetStream::Client.new.track('boston') do |status, client|
      client.stop if @tweetcount >= 20
      @tweetcount += 1
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

  searchable do
    text :text, :username
  end

end
