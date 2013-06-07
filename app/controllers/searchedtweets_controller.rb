require 'stoplist'

class SearchedtweetsController < ApplicationController
  before_filter :index
  before_filter :makedata

  def index
  end

  def makedata
    @pastsearches = Tweet.select([:inserted_at, :query]).uniq.where("query='" + params[:search] + "'")

    @oldid = ""
    @titletext = ""
    @catchempty = ""
    @idarray = []

    if params[:id].nil?
      if params[:search] != nil
        @searchterm = params[:search]
        system "rake loadtweetdb['" +  params[:search] + "']"
      end
      @searchedtweets = Tweet.where("query='" + params[:search] +"'").order('created_at asc')
      @oldid = params[:search]
      @idarray.push(@oldid)
    else
      @sqlquery = "query ='" + params[:search] + "'"
      if params[:snapshot] != nil
        if params[:snapshot] == 'alltweets'
          # 
        else
          @searchtime = params[:snapshot].to_date
          @sqlquery += " AND inserted_at ='" + params[:snapshot] +"'"
        end
      end

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
        if @stoplistarray.include?(word)
          wordFound = true
          break
        end
      end

      if wordFound == false
        @searchedtweetscopy.push(entry)
      end
    end
    else
      @searchedtweetscopy = @searchedtweets
    end

    @hash = Hash.new(0)
    @text_array = []
    @searchedtweetscopy.each do |entry|
      @text_array.push(entry.text.split(' '))
    end
    @paramsSearchArray = params[:search]
    @paramsSearchArray = @paramsSearchArray.split(' ')
    @text_array.each do |tweet|
      tweet.each do |word|
        word = word.downcase
        word = word.gsub(/[^0-9a-z  _@]/i, '')
        unless STOPLIST.include?(word) or @paramsSearchArray.include?(word) or word == "#" + params[:search] or @idarray.include?(word) or word.index('htt') or word.match('^[0-9]+$') or @stoplistarray.include?(word) or word.include?("@")
          @paramsSearchArray.each do |i|
            if word.include?(i)
              @hash.delete(word)
              break
            else
              @hash[word] += 1
            end
          end
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
      chart.xAxis(labels: {style: {}}, categories: @keyhash)
      chart.yAxis(title: 'Word Count', min: 0)
      chart.series(name: 'Word Count', yAxis: 0, type: 'bar', data: @valueshash)
      chart.legend(enabled: false)
      chart.tooltip(formatter: "function() { s='<b>' + this.series.name + '</b><br/>' + this.x + ': ' + this.y; return s;}")
      chart.plotOptions(bar: {cursor: 'pointer', point: { events: {click: "function() {
        var snapshot = $('#snapshot-string').text();
        if (snapshot == '') {
          $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + $('#id-string').text() + ':' + this.category + '&stoplistvar=' + $('#stoplist-string').text(), function(response) { $('#main-wrap').html(response);}, 'html');
      }
      else {
        $.get('/searchedtweets/_makedata?search=' + $('.search-input').val() + '&id=' + $('#id-string').text() + ':' + this.category + '&stoplistvar=' + $('#stoplist-string').text() + '&snapshot=' + snapshot, function(response) { $('#main-wrap').html(response);}, 'html');
      }
      }".squish}}})
    end
  end
end
