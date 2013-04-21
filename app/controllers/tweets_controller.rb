class TweetsController < ApplicationController
  def index
    Tweet.reindex
    #system "rake loadtweetdb[" + "boston" + "]"
    @tweets = Tweet.order("created_at desc")
  end
end
