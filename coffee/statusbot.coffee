irc = require 'irc'
settings = require '../settings'
request = require 'request'
cheerio = require 'cheerio'

# Connect to the IRC Server
bot = new irc.Client settings.server, settings.botName, settings
console.log "#{settings.botName} connecting to #{settings.server} #{settings.channels} ..."

current = {}
 
#==============================================================================#
#  IRC Event Bindings
#    - These handle bind actions on different types of low level IRC actions
#==============================================================================#

# Anytime you recieve a message update your status  
bot.addListener 'message', (nick, to, text, message) -> 
	getStatus(updateCurrent) if nick != settings.botName

# Anytime you recieve a ping update your status  
bot.addListener 'ping', (server) -> getStatus(updateCurrent) 

#==============================================================================#
#  Bot Actions
#     - These are thing githubbot does on some type of event 
#==============================================================================#
# Gets the current status of github
getStatus = (callback, channel) -> 
	request "https://status.github.com/messages", (err, res, html) ->
		if err or res.statusCode is 404
			return callback {type: 'major', message: 'Unable to connect to status.github.com', time: new Date()}, channel

		$ = cheerio.load(html);
		$message = $('.message').first();
		callback {
			type: $message.attr('class').replace("message", "").trim(), 
			message: $('.message .title').first().text(),
			time: new Date()
		}, channel

# Updates the current status message, and condtionally says it 
updateCurrent = (status, channel) ->
	shouldSay = true;

	shouldSay = false if current.type is 'good' and status.type is current.type

	shouldSay = false if current.message is status.message

	if shouldSay 
		bot.say channel, stringify status for channel in settings.channels

	current = status

stringify = (status) ->
	return "[#{status.time.toLocaleTimeString()}] #{status.message}"


