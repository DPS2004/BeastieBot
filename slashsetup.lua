local function slashsetup()

print('setting up slash commands')
-- you'll have to load application commands into discord first in order to use them.
-- however, after loading once, you don't have to load them everytime your bot loads.

-- gets a list of registered application commands from discord bot

-- deletes any existing application command from the bot's commands list
local oldglobalcommands = client:getGlobalApplicationCommands()
for globalcommandId in pairs(oldglobalcommands) do
	client:deleteGlobalApplicationCommand(globalcommandId)
end

if privatestuff.guildid then
	
	local oldcommands = client:getGuildApplicationCommands(privatestuff.guildid)
	for commandId in pairs(oldcommands) do
		client:deleteGuildApplicationCommand(privatestuff.guildid, commandId)
	end
end

_G['slashcommands'] = {}
_G['messagecommands'] = {}

--[[
local slashCommand = {}
local option = {}


-- creates a slash command constructor
slashCommand = slashtools.slashCommand("blep", "Send a random adorable animal photo")
-- creates a string option constructor
option = slashtools.string("animal", "The type of the animal")
-- adds three choices into the option
option = option:addChoice(slashtools.choice("Dog", "animal_dog"))
option = option:addChoice(slashtools.choice("Cat", "animal_cat"))
option = option:addChoice(slashtools.choice("Penguin", "animal_penguin"))
-- and sets as a required option
option = option:setRequired(true)
-- adds option into slash command "blep"
slashCommand = slashCommand:addOption(option)

-- creates another string option constructior
option = tools.string("only_smol", "Whether to show only baby animals")
-- adds another option into slash command "blep"
slashCommand = slashCommand:addOption(option)

-- creates user command and message command
local userCommand = tools.userCommand("Get avatar")
local messageCommand = tools.messageCommand("Look message")

-- register application commands into the bot's commands
CLIENT:createGlobalApplicationCommand(slashCommand)
CLIENT:createGlobalApplicationCommand(userCommand)
CLIENT:createGlobalApplicationCommand(messageCommand)

CLIENT:info("Ready!");
]]
local function loadslash(filename, name)
	name = name or filename
	local command, rfunc = dofile('slashcommand/'..filename..'.lua')
	if privatestuff.guildid then
		client:createGuildApplicationCommand(privatestuff.guildid, command)
	else
		client:createGlobalApplicationCommand(command)
	end
	slashcommands[name] = rfunc
end

local function loadmessage(filename, name)
	name = name or filename
	local command, rfunc = dofile('messagecommand/'..filename..'.lua')
	if privatestuff.guildid then
		client:createGuildApplicationCommand(privatestuff.guildid, command)
	else
		client:createGlobalApplicationCommand(command)
	end
	messagecommands[name] = rfunc
end


--load the commands
--loadslash('slashtest')
loadslash('enable')
loadslash('disable')
loadslash('webhooktest')
loadslash('enablerandom')
loadslash('disablerandom')

loadmessage('respond')



--end loading

client:on('slashCommand', function(interaction, command, args)
	local user = interaction.member or interaction.user
	
	
	local channel = interaction.channel
	args = args or {}
	if not slashcommands[command.name] then
		print('tried to run non-existing command '.. command.name)
		return
	end
	slashcommands[command.name](interaction, command, args, user, channel)
end)

client:on("messageCommand", function(interaction, command, message)
	local user = interaction.member or interaction.user
	local channel = interaction.channel
	if not messagecommands[command.name] then
		print('tried to run non-existing command '.. command.name)
		return
	end
	if not message then
		print('could not access message')
		return
	end
	messagecommands[command.name](interaction, command, message, user, channel)
end)



end

return slashsetup