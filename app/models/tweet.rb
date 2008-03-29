require 'twitter'
class Tweet < ActiveRecord::Base
  cattr_accessor :twitter_username, :twitter_password, :jabber_username, :jabber_password
  
  def self.load_config
    data = YAML.load_file(File.join(RAILS_ROOT, 'config', 'twitter.yml'))
    self.twitter_username = data['twitter_username']
    self.twitter_password = data['twitter_password']
    self.jabber_username = data['jabber_username']
    self.jabber_password = data['jabber_password']
    true
  end
  
  def self.twit
    @twit ||= Twitter::Base.new(twitter_username, twitter_password)
  end
  
  def self.reload_tweet(id)
    s = twit.status(id)
    handle_tweet(s.user.screen_name, s.text, s)
  end
  
  def self.handle_tweet(username, message, entry)
    data = parse_tweet(message)
    return if data[:message].nil?

    self.find_or_create_by_tweet_id(:tweet_id => entry.id, :text => data[:message].strip, :tweeted_at => entry.created_at, :screen_name => username)
  end
  
  def self.parse_tweet(msg)
    msg =~ /^sign\:(.*)/i
    {:message => $1}
  end

  def self.from_friends
    twit.timeline.each do |s|
      next unless s.text =~ /sign\:/i
      self.find_or_create_by_tweet_id(:tweet_id => s.id, :text => s.text.gsub(/sign\:/i, '').strip, :tweeted_at => s.created_at, :screen_name => s.user.screen_name)
    end
  end
  
  def self.follow_followers
    friends = twit.friends.collect { |f| f.screen_name }
    twit.followers.each do |f|
      next if friends.include?(f.screen_name)
      twit.create_friendship(f.screen_name)
    end
  end
  
  
end
