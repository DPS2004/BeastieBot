--------------Setup---------------
local commandname = 'slashtest'
local commanddescription = 'description'



local command = slashtools.slashCommand(commandname, commanddescription)

local option_foobar = slashtools.string('foobar', 'Foo, or Bar?')

option_foobar:addChoice(slashtools.choice('Foo!', 'foo'))
option_foobar:addChoice(slashtools.choice('Bar!', 'bar'))

option_foobar:setRequired(true)

command:addOption(option_foobar)



--------------On Use---------------
local function rfunc(interaction, command, args, user, channel)
	interaction:reply('user selected option with ID of '..args.foobar)
end

return command, rfunc