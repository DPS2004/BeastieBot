--------------Setup---------------
local commandname = 'respond'



local command = slashtools.messageCommand(commandname)



--------------On Use---------------
local function rfunc(interaction, command, message, user, channel)
	webhooks[channel.guild.id] = webhooks[channel.guild.id] or {}
	if not webhooks[channel.guild.id][channel.id] then
		interaction:reply('No webhook found for this channel.',true)
		return
	end
	
	local id = webhooks[channel.guild.id][channel.id][1]
	local token = webhooks[channel.guild.id][channel.id][2]
	
	interaction:reply('Done!',true)
	
	sendbeasties(id,token,message.content)
end

return command, rfunc