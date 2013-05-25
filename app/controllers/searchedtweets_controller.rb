require 'stoplist'

class SearchedtweetsController < ApplicationController
  before_filter :index
  before_filter :makedata
  before_filter :header

  def index
  end
  
  def header
  end

  def makedata
    @pastsearches = Tweet.find_by_sql(["SELECT distinct inserted_at,query from tweets where query='" + params[:search] + "'"])

    @oldid = ""
    @titletext = ""
    @catchempty = ""
    @idarray = []

    if params[:id].nil?
      if params[:search] != nil
        system "rake loadtweetdb[" + params[:search] + "]"
      end
      @searchedtweets = Tweet.find_by_sql(["SELECT * FROM tweets WHERE query='" + params[:search] + "' ORDER BY created_at"])
      @oldid = params[:search]
      @idarray.push(@oldid)
    else
      if params[:snapshot] != nil
        @searchedtweets = Tweet.find_by_sql(["SELECT * FROM tweets WHERE query='" + params[:search] + "' AND inserted_at='" + params[:snapshot] + "' ORDER BY created_at"])  
        @searchtime = params[:snapshot].to_date
      end
      @sqlquery = "query ='" + params[:search] + "'"
      @oldid = params[:id]
      @idarray = @oldid.split(':')
      @idarray.shift
      @idarray.each do |i|
        @sqlquery += " AND text LIKE '%" + i + "%'"
        @titletext += ' and "' + i + '"'
      end

      @idarray.insert(0, params[:search]) # add search param to front of array
      @searchedtweets = Tweet.where(@sqlquery).order('created_at asc')
      if @searchedtweets.count == 0
        @catchempty = "No Results Found"
      end

    end

    @stoplistarray = ""
    @searchedtweetscopy = []
   if params[:stoplistvar] != nil
     @stoplistarray = []
     @stoplistarray = params[:stoplistvar]
     @stoplistarray.split(',')

     @searchedtweets.each do |entry|
        @temparray = []
        @temparray = entry.text.split(' ')
        wordFound = false

        @temparray.each do |word|
          word = word.downcase
          # word = word.gsub(/[^0-9a-z  _@]/i, '')
          if @stoplistarray.include?(word)
            wordFound = true
            puts wordFound
            puts word
            puts "skipping--------------------------------"
            puts entry.text
            break
          end
        end

        if wordFound == false
          puts "SAVING************************************"
          puts entry.text
          @searchedtweetscopy.push(entry)
        end

     end
     # @searchedtweetscopy = @searchedtweets

   else
      @searchedtweetscopy = @searchedtweets
   end

    @hash = Hash.new(0)
    @text_array = []
    @searchedtweetscopy.each do |entry|
      @text_array.push(entry.text.split(' '))
    end
    @text_array.each do |tweet|
      tweet.each do |word|
        word = word.downcase
        # word = word.delete("^a-zA-Z ")
        word = word.gsub(/[^0-9a-z  _@]/i, '')
        unless STOPLIST.include?(word) or word == params[:search] or word == "#" + params[:search] or @idarray.include?(word) or word.index('htt') or word.match('^[0-9]+$') or @stoplistarray.include?(word)
          @hash[word] += 1
        end
      end
    end
    @sortedhash = @hash.sort_by {|_key, value| value}.reverse

    @keyhash = []
    @valueshash = []
    @sortedhash.first(15).each do |key, value|
      @keyhash.push(key)
      @valueshash.push(value)
    end

    @chart = Highcharts.new do |chart|
      chart.chart(renderTo: 'graph', plotShadow: true)
      chart.title('')
      chart.credits(enabled: false)
      chart.xAxis(categories: @keyhash)
      # chart.scrollbar(enabled: true)
      chart.yAxis(title: 'Word Count', min: 0)
      chart.series(name: 'Word Count', yAxis: 0, type: 'bar', data: @valueshash)
      chart.legend(enabled: false)
      chart.tooltip(formatter: "function() { s='<b>' + this.series.name + '</b><br/>' + this.x + ': ' + this.y; return s;}")
      chart.plotOptions(bar: {cursor: 'pointer', point: { events: {click: "function() {
        $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + $('#id-string').text() + ':' + this.category + '&stoplistvar=' + $('#stoplist-string').text() + '&snapshot=' + $('#snapshot-string').text(), function(response) { $('#main-wrap').html(response);}, 'html');
          }".squish}}})

    end
  end

end
