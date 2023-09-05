--------------Setup---------------
local commandname = 'disablerandom'
local commanddescription = 'Stops BeastieBot from randomly responding to messages in this channel.'



local command = slashtools.slashCommand(commandname, commanddescription)
--[[
local option_foobar = slashtools.string('foobar', 'Foo, or Bar?')

option_foobar:addChoice(slashtools.choice('Foo!', 'foo'))
option_foobar:addChoice(slashtools.choice('Bar!', 'bar'))

option_foobar:setRequired(true)

command:addOption(option_foobar)
]]--



--------------On Use---------------
local function rfunc(interaction, command, args, user, channel)
	local canuse = user.hasPermission and user:hasPermission(channel,'manageChannels')
	if not canuse then
		interaction:reply('You do not have the Manage Channels permission, which is required for this command.',true)
		return
	end
	
	

	
	local randomchannels = getsetting(channel.guild.id,'randomchannels')
	randomchannels[channel.id] = 0
	setsetting(channel.guild.id,'randomchannels',randomchannels)
	

	interaction:reply('Disabled random responses for this channel.',true)
end

return command, rfunc