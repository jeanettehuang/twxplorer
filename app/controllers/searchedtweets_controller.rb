class SearchedtweetsController < ApplicationController
  def index
    @search = Tweet.search do
      fulltext params[:search]
    end
    @searchedtweets = @search.results
  end
end
