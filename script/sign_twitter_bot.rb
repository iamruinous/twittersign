require 'logger'
require File.dirname(__FILE__) + '/../config/boot'
require File.dirname(__FILE__) + '/../config/environment'
require File.dirname(__FILE__) + '/../lib/sign_twitter_bot'

PROPS_TWITTER_USERNAME = Tweet.twitter_username
PROPS_TWITTER_PASSWORD = Tweet.twitter_password
PROPS_JABBER_ID = Tweet.jabber_username
PROPS_JABBER_PASSWORD = Tweet.jabber_password


logger = Logger.new(File.join(RAILS_ROOT, 'log', 'twitter_bot.log'))
props_twitter_bot = SignTwitterBot.new(logger)
props_twitter_bot.runn