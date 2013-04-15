class SearchedtweetsController < ApplicationController
  def index
    Tweet.reindex
    @search = Tweet.search do
      fulltext params[:search]
    end
    @searchedtweets = @search.results
  end
end
