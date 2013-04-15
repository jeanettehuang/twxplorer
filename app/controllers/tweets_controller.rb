class TweetsController < ApplicationController
  def index
    @search = Tweet.search do
      fulltext params[:search]
    end
    @tweets = @search.results
    # @tweets = Tweet.order("created_at desc")
  end

end
