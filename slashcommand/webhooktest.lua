--------------Setup---------------
local commandname = 'webhooktest'
local commanddescription = 'Test the webhook in this channel.'



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
		interaction:reply('No webhook found for this channel.',true)
		return
	end
	local id = webhooks[channel.guild.id][channel.id][1]
	local token = webhooks[channel.guild.id][channel.id][2]
	local result = client._api:executeWebhook(id, token, {
		content = 'This is a test of webhook ' .. id,
		avatar_url = 'https://cdn.discordapp.com/attachments/830582530045378563/1146958548794880100/image.png'
	})
	if result == nil then
		interaction:reply('Test complete. It seems something went wrong, though! \nGuild: ' .. channel.guild.id .. '\nChannel: ' .. channel.guild.id .. '\nWebhook: ' .. id ,true)
	else
		interaction:reply('Test complete. Everything seems good!',true)
	end
end

return command, rfunc