# coding: utf-8
require 'elephrame'
require 'time'
require 'syslog/logger'

log = Syslog::Logger.new 'meowd'

# our helping of mews
Mews = [ 'meow', 'mew', 'purr', 'ₘₑ𝓌',
         'ᴍᴇᴡ', 'ₚᵤᵣᵣ', '¿𝓌ₒₒ𝒻?',
         'ᴍᴇᴏᴡ' ]

# set this to 1 minute so we post almost immediately
meowd = Elephrame::Bots::PeriodInteract.new '1m'

meowd.on_reply { |bot, post|
  # reply to mentions with a random mew
  mew = Mews.sample
  
  bot.reply_with_mentions(mew)
  log.info "replied to #{post.account.acct} with #{mew}"
}

meowd.run { |bot|
  # post a random mew to the fediverse and send it
  #  to the syslog ;3
  mew = Mews.sample
  bot.post(mew, visibility: 'public')
  log.info mew
  
  # change the next post time to somewhere
  #  between now and 2 hours from now
  bot.schedule.next_time = Time.now + rand() * 2 * 3600
}
