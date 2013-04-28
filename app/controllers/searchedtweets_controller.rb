require 'stoplist'

class SearchedtweetsController < ApplicationController
  def index
   #  if params[:search] != nil 
   #    system "rake loadtweetdb[" + params[:search] + "]"
   #  end
   # @searchedtweets = Tweet.find_by_sql(["SELECT * FROM tweets WHERE query='" + params[:search] + "'"])
   @searchedtweets = Tweet.order("created_at desc")

    @hash = Hash.new(0)
    @text_array = []
    @searchedtweets.each do |entry|
      @text_array.push(entry.text.split(' '))
    end
    @text_array.each do |tweet|
      tweet.each do |word|
        word = word.downcase
        word = word.gsub(/[^0-9a-z ]/i, '')
        unless STOPLIST.include?(word) or word == params[:search] or word == "#" + params[:search]
          @hash[word] += 1
        end
      end
    end
    @sortedhash = @hash.sort_by {|_key, value| value}.reverse

    @keyhash = []
    @valueshash = []
    @sortedhash.first(10).each do |key, value|
      @keyhash.push(key)
      @valueshash.push(value)
    end

    @chart = Highcharts.new do |chart|
      chart.chart(renderTo: 'graph', plotShadow: true)
      chart.title('')
      chart.credits(enabled: false)
      chart.xAxis(categories: @keyhash)
      chart.yAxis(title: 'Word Count', min: 0)
      chart.series(name: 'Word Count', yAxis: 0, type: 'bar', data: @valueshash)
      chart.legend(enabled: false)
      chart.tooltip(formatter: "function() { s='<b>' + this.series.name + '</b><br/>' + this.x + ': ' + this.y; return s;}")
    end
  end
end