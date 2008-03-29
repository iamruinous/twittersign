# THIS WAS MOSTLY TAKEN FROM http://dominiek.com/articles/2008/2/15/how-to-build-a-twitter-agent

require File.dirname(__FILE__) + '/../lib/twitter_bot'
require 'drb'

class SignTwitterBot < TwitterBot
  attr_accessor :logger
  
  def initialize(logger)
    self.logger = logger
    super(PROPS_TWITTER_USERNAME, PROPS_TWITTER_PASSWORD, PROPS_JABBER_ID, PROPS_JABBER_PASSWORD)
  end
  
  def runn
    self.track_phrases = ['sign:']
    logger.info("starting SignTwitterBot, twitter_username: #{PROPS_TWITTER_USERNAME}, jabber_id: #{PROPS_JABBER_ID}")

    self.on_tweet do |username, message, entry|
      logger.info("#{username} said '#{message}'")
      Tweet.handle_tweet(username, message, entry)
    end
    
    # These events are generated every 120 secs :(
    self.on_follow do |username|
      logger.info("#{username} is following us, will follow #{username} too and send welcome message")
      follow(username)
      self.direct_message(username, "to send in a sign use sign: whatever the sign you saw.")
    end
    self.on_unfollow do |username|
      logger.info("#{username} stopped following us")
    end
    DRb.start_service("druby://:8998", self)
    super(:follow_all_followers => false)
  end
  
  def track_phrase(message)
    logger.info(message)
    match_phrase('track', message)
  end
  
  def untrack_phrase(message)
    match_phrase('off', message)
  end
  
private

  def match_phrase(command, message)
    expression = Regexp.new("^[\s]*#{command}[\s]+['\"]*([^'\"]+)['\"]*")
    if (md = expression.match(message))
      phrase = md[1]
      if phrase.size < 4
        return nil
      end
      return phrase
    end
    nil
  end
  
end
