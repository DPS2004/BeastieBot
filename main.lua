_G["discordia"] = require('discordia')
--_G["dcomponents"] = require("discordia-components")
_G["discordiaslash"] = require("discordia-slash")
_G["slashtools"] = discordiaslash.util.tools()

_G["client"] = discordia.Client()
client:useApplicationCommands()

_G["privatestuff"] = require('privatestuff')

--_G["prefix"] = "c!"
_G["json"] = require('libs/json')
_G["fs"] = require('fs')
--from https://github.com/DeltaF1/lua-tracery, TODO properly follow the license lmao
--_G["tracery"] = require('libs/tracery')
_G["dpf"] = require('libs/dpf')
_G["inspect"] = require('libs/inspect')
--_G["prosel"] = require('libs/prosel')
--_G["vips"] = require('vips')
--_G["http"] = require('coro-http')

-- load all the extensions
discordia.extensions()


_G['beastiedata'] = dpf.loadjson('beasties/data.json')

_G['getword'] = function(text)
	text = text:gsub("%p"," ")
	local textresult = ''
	for textmatch in text:gmatch("%S+") do textresult = textmatch end
	textresult = '**'..string.upper(textresult)..'**'
	return textresult
end

_G['sendbeasties'] = function(id,token,text,allthree)
	
	textresult = getword(text)
	if allthree == nil then
		allthree = true
	end
	
	
	local function onebeastie(num)
		client._api:executeWebhook(id, token, {
			content = textresult,
			username = beastiedata[num].name,
			avatar_url = beastiedata[num].images[math.random(1,#beastiedata[num].images)]
		})
	end
	
	if allthree then
		for i=1,3 do
			onebeastie(i)
		end
	else
		onebeastie(math.random(1,3))
	end

end

_G['defaultsettings'] = {
	allthree = true,
	randomchannels = {}
}

_G['setsetting'] = function(id,name,value)
	if not settings[id] then 
		print('added settings profile for server ' .. id)
		settings[id] = defaultsettings
	end
	if not defaultsettings[name] then
		error('Tried to set unidentified setting "'..name..'"!')
	end

	settings[id][name] = value
	dpf.savejson('savedata/settings.json',settings)
end

_G['getsetting'] = function(id,name)
	if not settings[id] then 
		print('added settings profile for server ' .. id)
		settings[id] = defaultsettings
		dpf.savejson('savedata/settings.json',settings)
	end
	local returnsetting = settings[id][name] or defaultsettings[name]
	if not returnsetting then
		error('Tried to get unidentified setting "'..name..'"!')
	end
	return returnsetting
	
end

client:on("ready",function()
	_G["settings"] = dpf.loadjson("savedata/settings.json",{})
	_G["webhooks"] = dpf.loadjson("savedata/webhooks.json",{})
	dofile('slashsetup.lua')()
end)

client:on('messageCreate', function(message)
	if message.webhookId or message.author.bot then
		return
	end
	if not message.guild then
		message:reply(getword(message.content)) --dms
		return
	end
	
	
	local randomchannels = getsetting(message.guild.id,'randomchannels')
	local chance = randomchannels[message.channel.id] or 0
	if chance == 0 then
		return
	end
	if chance >= math.random() then
		webhooks[message.channel.guild.id] = webhooks[message.channel.guild.id] or {}
		if not webhooks[message.channel.guild.id][message.channel.id] then
			return
		end
		
		local id = webhooks[message.channel.guild.id][message.channel.id][1]
		local token = webhooks[message.channel.guild.id][message.channel.id][2]
		
		sendbeasties(id,token,message.content)
	end
end)



client:run(privatestuff.botid)

client:setActivity({name = "DJ Hero 3", type = "PLAYING"})