require 'csv'

class ExportController < ApplicationController
  def exporttweets

    @sqlquery = "query ='" + params[:searchterm] + "'"
    @csvtitle = params[:searchterm] + ".csv"
    if params[:snapshot] != nil
      @sqlquery += " AND inserted_at ='" + params[:snapshot] +"'"
      @csvtitle = params[:searchterm] + "_" + params[:snapshot] + ".csv"
    end

    @tweetstoexport = Tweet.where(@sqlquery).order('created_at asc')

    respond_to do |format|
      format.html
      format.csv {send_data @tweetstoexport.as_csv, filename: @csvtitle}
    end

  end
end