--------------Setup---------------
local commandname = 'enablerandom'
local commanddescription = 'Enables BeastieBot to randomly respond to messages in this channel.'



local command = slashtools.slashCommand(commandname, commanddescription)
--[[
local option_foobar = slashtools.string('foobar', 'Foo, or Bar?')

option_foobar:addChoice(slashtools.choice('Foo!', 'foo'))
option_foobar:addChoice(slashtools.choice('Bar!', 'bar'))

option_foobar:setRequired(true)

command:addOption(option_foobar)
]]--
local option_chance = slashtools.number('chance', 'The chance of a message being replied to. Default: 0.01')
option_chance:setRequired(false)
option_chance:setMinValue(0)
option_chance:setMaxValue(1)
command:addOption(option_chance)




--------------On Use---------------
local function rfunc(interaction, command, args, user, channel)
	local canuse = user.hasPermission and user:hasPermission(channel,'manageChannels')
	if not canuse then
		interaction:reply('You do not have the Manage Channels permission, which is required for this command.',true)
		return
	end
	
	
	--check for webhook
	webhooks[channel.guild.id] = webhooks[channel.guild.id] or {}
	
	local madewebhook = false
	if not webhooks[channel.guild.id][channel.id] then
		local newhook = channel:createWebhook("BeastieBot webhook")
		local id = newhook.id
		local token = newhook.token
		if (not id) or (not token) then
			interaction:reply('Failed to create webhook properly! No ID or token was provided.',true)
			return
		end
		
		webhooks[channel.guild.id][channel.id] = {id, token}
		dpf.savejson('savedata/webhooks.json', webhooks)
		print('Created a new webhook in ' .. channel.guild.name .. '/' ..channel.name)
		madewebhook = true
	end
	
	local setchance = args.chance or 0.01
	local randomchannels = getsetting(channel.guild.id,'randomchannels')
	randomchannels[channel.id] = setchance
	setsetting(channel.guild.id,'randomchannels',randomchannels)
	
	local respondtext = 'Set chance for this channel to ' .. setchance .. '. '
	if madewebhook then
		respondtext = respondtext .. 'Also, a webhook was created.'
	end
	interaction:reply(respondtext,true)
end

return command, rfunc