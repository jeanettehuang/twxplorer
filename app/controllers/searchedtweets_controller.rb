require 'stoplist'

class SearchedtweetsController < ApplicationController
  before_filter :getvars
  before_filter :index
  before_filter :makedata

  def index
  end

  def rendermakedata 
    render :partial => 'makedata'
  end

  def makedata
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
        unless STOPLIST.include?(word) # or word == params[:search] or word == "#" + params[:search]
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
      # chart.plotOptions(bar: {cursor: 'pointer', point: { events: {click: "function() {
      #   jQuery.ajax({
      #     type:'GET',
      #     url: '_makedata',
      #     dataType:'json',
      #     data:'id=' + this.category});}".squish}}})
      
      chart.plotOptions(bar: {cursor: 'pointer', point: { events: {click: "function() {
        $.get('/searchedtweets/_makedata?id=' + this.category, function(response) { $('#main-wrap').html(response);});
          }".squish}}})

    end
  end

  def getvars
    @test = params[:id]
   # render :partial => 'getvars'
  end
end
