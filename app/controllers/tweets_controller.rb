class TweetsController < ApplicationController
  def index
    if params[:search] != nil 
      system "rake loadtweetdb[" + params[:search] + "]"
    end
    Tweet.reindex
    @search = Tweet.search do
      fulltext params[:search]
    end
    @tweets = @search.results
  end
end
