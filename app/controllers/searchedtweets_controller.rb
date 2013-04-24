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
      unless STOPLIST.include?(word.downcase) or word.downcase == params[:search] or word.downcase == "#" + params[:search]
        @hash[word.downcase] += 1
      end
    end
  end
  @sortedhash = @hash.sort_by {|_key, value| value}.reverse

  @keyhash = []
  @valueshash = []
  @sortedhash.first(5).each do |key, value|
    @keyhash.push(key)
    @valueshash.push(value)
  end
  
  @chart = Highcharts.new do |chart|
    chart.chart(renderTo: 'graph')
    chart.title('')
    chart.credits(enabled: false)
    chart.xAxis(categories: @keyhash)
    chart.yAxis(title: 'Word Count', min: 0)
    chart.series(name: 'Word Count', yAxis: 0, type: 'column', data: @valueshash)
    chart.legend(enabled: false)
    chart.tooltip(formatter: "function(){ return '<b>' + this.series.name + '</b><br/>' + this.x + ': ' + this.y; }")
  end
    
  end

end