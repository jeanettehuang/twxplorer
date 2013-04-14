class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :text
      t.string :username
      t.datetime :created_at
      t.string :guid
      t.string :lang
      t.string :time_zone

      t.timestamps
    end
  end
end
