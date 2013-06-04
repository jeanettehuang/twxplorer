class Tweet < ActiveRecord::Base
  attr_accessible :created_at, :guid, :lang, :text, :time_zone, :username, :query, :avatar, :name, :inserted_at
  # searchable do
  #   text :query
  # end

  def self.as_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

end
