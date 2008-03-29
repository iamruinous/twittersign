# THIS WAS MOSTLY TAKEN FROM http://dominiek.com/articles/2008/2/15/how-to-build-a-twitter-agent

require 'xmpp4r/client'

class JabberBot < Jabber::Client
  include Jabber
  
  def initialize(jabber_id, jabber_password, options = {})
    @jabber_id = jabber_id
    @jabber_password = jabber_password
    @options = options
    jid = JID::new(@jabber_id)
    super(jid)
  end
  
  def on_message(from, body)
    raise "on_message not implemented!"
  end
  
  def connect_and_authenticate
    connect
    auth(@jabber_password)
    send(Presence::new)
  end
  
  def run
    main = Thread.current
    add_message_callback { |message|
      next if message.type == :error or message.body.blank?
      # support exit command if owner is set
      main.wakeup if @options[:owner_jabber_id] == message.from && message.body == 'exit'
      # simple callback
      self.on_message(message.from, message.body, message.first_element('entry'))
    }
    Thread.stop
    close
  end
  
  def say(jabber_id, body)
    send(Message::new(jabber_id, body).set_type(:chat).set_id('1'))
  end
  
end
