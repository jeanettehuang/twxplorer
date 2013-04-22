class Tweet < ActiveRecord::Base
  attr_accessible :created_at, :guid, :lang, :text, :time_zone, :username, :query

  searchable do
    text :query
  end

end
