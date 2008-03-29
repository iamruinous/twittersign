class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :tweet_id
      t.string :text, :screen_name
      t.datetime :tweeted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :tweets
  end
end
