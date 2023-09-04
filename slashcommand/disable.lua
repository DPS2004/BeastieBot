--------------Setup---------------
local commandname = 'disable'
local commanddescription = 'Stops BeastieBot from using this channel'



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
	if webhooks[channel.guild.id][channel.id] then
	
		
		webhooks[channel.guild.id][channel.id] = nil
		dpf.savejson('savedata/webhooks.json', webhooks)
		print('Deleted webhook in ' .. channel.guild.name .. '/' ..channel.name)
		
		interaction:reply('Disabled! (A webhook has been deleted in this channel.)',true)
		
	else
		interaction:reply('Disabled! (Did not delete any webhooks.)',true)
	end
end

return command, rfunc