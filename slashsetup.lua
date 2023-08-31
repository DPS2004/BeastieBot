local function slashsetup()

print('setting up slash commands')
-- you'll have to load application commands into discord first in order to use them.
-- however, after loading once, you don't have to load them everytime your bot loads.

-- gets a list of registered application commands from discord bot
local oldcommands = client:getGlobalApplicationCommands()
-- deletes any existing application command from the bot's commands list
for commandId in pairs(oldcommands) do
	client:deleteGlobalApplicationCommand(commandId)
end

_G['slashcommands'] = {}

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
local function loadslash(name)
	local command, rfunc = dofile('slashcommand/'..name..'.lua')
	client:createGlobalApplicationCommand(command)
	slashcommands[name] = rfunc
end

loadslash('slashtest')

client:on('slashCommand', function(interaction, command, args)
	slashcommands[command.name](interaction, command, args)
end)
end

return slashsetup