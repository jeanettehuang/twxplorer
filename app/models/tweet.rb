class Tweet < ActiveRecord::Base
  attr_accessible :created_at, :guid, :lang, :text, :time_zone, :username, :query, :avatar, :name, :inserted_at
  searchable do
    text :query
  end
end
