class AddInsertedToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :inserted_at, :date
  end
end
