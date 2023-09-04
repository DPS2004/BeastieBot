--------------Setup---------------
local commandname = 'enable'
local commanddescription = 'Enables BeastieBot to use this channel'



local command = slashtools.slashCommand(commandname, commanddescription)
--[[
local option_foobar = slashtools.string('foobar', 'Foo, or Bar?')

option_foobar:addChoice(slashtools.choice('Foo!', 'foo'))
option_foobar:addChoice(slashtools.choice('Bar!', 'bar'))

option_foobar:setRequired(true)

command:addOption(option_foobar)
]]



--------------On Use---------------
local function rfunc(interaction, command, args, user, channel)
	local canuse = user.hasPermission and user:hasPermission(channel,'manageChannels')
	if not canuse then
		interaction:reply('You do not have the Manage Channels permission, which is required for this command.',true)
		return
	end
	
	
	--check for webhook
	webhooks[channel.guild.id] = webhooks[channel.guild.id] or {}
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
		
		interaction:reply('Enabled! (A webhook has been created in this channel.)',true)
		
	else
		interaction:reply('Enabled! (Did not create any webhooks.)',true)
	end
end

return command, rfunc