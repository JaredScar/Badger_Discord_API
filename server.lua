local FormattedToken = "Bot " .. Config.Bot_Token
local roleGuilds = {}
local roleNames = {}

local error_codes_defined = {
	[200] = 'OK - The request was completed successfully..!',
	[204] = 'OK - No Content',
	[400] = "Error - The request was improperly formatted, or the server couldn't understand it..!",
	[401] = 'Error - The Authorization header was missing or invalid..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[403] = 'Error - The Authorization token you passed did not have permission to the resource..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[404] = "Error - The resource at the location specified doesn't exist.",
	[429] = 'Error - Too many requests, you hit the Discord rate limit. https://discord.com/developers/docs/topics/rate-limits',
	[502] = 'Error - Discord API may be down?...'
};

Citizen.CreateThread(function()
	if (GetCurrentResourceName() ~= "Badger_Discord_API") then 
		--StopResource(GetCurrentResourceName());
		print("[" .. GetCurrentResourceName() .. "] " .. "IMPORTANT: This resource must be named Badger_Discord_API for it to work properly with other scripts...");
	end
	print("[Badger_Discord_API] For support, make sure to join Badger's official Discord server: discord.gg/WjB5VFz");
	print('^7[^2Zap-Hosting^7] ^3Use code ^5TheWolfBadger-4765 ^3at checkout for ^220% ^3off of selected services. Visit ^5https://zap-hosting.com/badger ^3to get started!');
end)

function sendDebugMessage(msg)
	print("^1[^5Badger_Discord_API^1] ^3" .. msg);
end

tracked = {}

RegisterNetEvent('Badger_Discord_API:PlayerLoaded')
AddEventHandler('Badger_Discord_API:PlayerLoaded', function()
	if (GetCurrentResourceName() ~= "Badger_Discord_API") then 
		TriggerClientEvent('chatMessage', -1, '^1[^5SCRIPT ERROR^1] ^3The script ^1' .. GetCurrentResourceName() .. ' ^3will not work properly... You must '
	.. 'rename the resource to ^1Badger_Discord_API');
	end
	local license = GetIdentifier(source, 'license');
	if (tracked[license] == nil) then 
		tracked[license] = true;
		TriggerClientEvent('chatMessage', source, 
		'^1[^5Badger_Discord_API^1] ^3The Discord API script was created by Badger. You may join his Discord at: ^6discord.gg/WjB5VFz')
	end
	TriggerClientEvent('chatMessage', source, 
		'^7[^2Zap-Hosting^7] ^3Use code ^5TheWolfBadger-4765 ^3at checkout for ^220% ^3off of selected services. Visit ^5https://zap-hosting.com/badger ^3to get started!');
end)

card = '{"type":"AdaptiveCard","$schema":"http://adaptivecards.io/schemas/adaptive-card.json","version":"1.4","body":[{"type":"Image","url":"' .. Config.Splash.Header_IMG .. '","horizontalAlignment":"Center"},{"type":"Container","items":[{"type":"TextBlock","text":"Badger_Discord_API","wrap":true,"fontType":"Default","size":"ExtraLarge","weight":"Bolder","color":"Light","horizontalAlignment":"Center"},{"type":"TextBlock","text":"' .. Config.Splash.Heading1 .. '","wrap":true,"size":"Large","weight":"Bolder","color":"Light","horizontalAlignment":"Center"},{"type":"TextBlock","text":"' .. Config.Splash.Heading2 .. '","wrap":true,"color":"Light","size":"Medium","horizontalAlignment":"Center"},{"type":"ColumnSet","height":"stretch","minHeight":"100px","bleed":true,"horizontalAlignment":"Center","columns":[{"type":"Column","width":"stretch","items":[{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Discord","url":"' .. Config.Splash.Discord_Link .. '","style":"positive"}],"horizontalAlignment":"Right"}],"height":"stretch"},{"type":"Column","width":"stretch","items":[{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Website","style":"positive","url":"' .. Config.Splash.Website_Link .. '"}],"horizontalAlignment":"Left"}]}]},{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Click to join Badger\'s Discord","style":"destructive","iconUrl":"https://i.gyazo.com/0904b936e8e30d0104dec44924bd2294.gif","url":"https://discord.com/invite/WjB5VFz"}],"horizontalAlignment":"Center"}],"style":"default","bleed":true,"height":"stretch"},{"type":"Image","url":"https://i.gyazo.com/7e896862b14be754ae8bad90b664a350.png","selectAction":{"type":"Action.OpenUrl","url":"https://zap-hosting.com/badger"},"horizontalAlignment":"Center"}]}'
if Config.Splash.Enabled then 
	AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) 
		-- Player is connecting
		deferrals.defer();
		local src = source;
		local toEnd = false;
		local count = 0;
		while not toEnd do 
			deferrals.presentCard(card,
			function(data, rawData)
			end)
			Wait((1000))
			count = count + 1;
			if count == Config.Splash.Wait then 
				toEnd = true;
			end
		end
		deferrals.done();
	end)
end 

function GetIdentifier(source, id_type)
    if type(id_type) ~= "string" then return; end
    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if string.find(identifier, id_type) then
            return identifier
        end
    end
    return nil
end

function GetGuildId (guildName)
  local result = tostring(Config.Guild_ID)
  if guildName and Config.Guilds[guildName] then
    result = tostring(Config.Guilds[guildName])
  end
  return result
end

function DiscordRequest(method, endpoint, jsondata, reason)
    local data = nil
    PerformHttpRequest("https://discord.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and jsondata or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken, ['X-Audit-Log-Reason'] = reason})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function GetRoleIdFromRoleName(name, guild --[[optional]])
  local guildId = GetGuildId(guild)
	if (Caches.RoleList[guildId] ~= nil) then 
		return tonumber(Caches.RoleList[guildId][name]);
	else 
		local roles = GetGuildRoleList(guild);
		return tonumber(roles[name]);
	end
end

function FetchRoleID(roleID2Check, guild --[[optional]])
    -- You gave me an ID, here it is back to you.
    if type(roleID2Check) == "number" then return roleID2Check end
    -- You gave me a non-string, non-number. I can't help you.
    if type(roleID2Check) ~= "string" then return nil end

	if type(roleID2Check) == "string" then 
		if (tonumber(roleID2Check) ~= nil) then 
			return tonumber(roleID2Check);
		end
	end

    -- It's a string, therefore name -- search config rolelist
    local rolesListFromConfig = Config.RoleList
    if rolesListFromConfig[roleID2Check] then
      -- It's a named role in the config. Here you go!
      return tonumber(rolesListFromConfig[roleID2Check])
    end
    -- Oops, didn't find in config rolelist, search by name in current guild
    if (guild ~= nil) then 
        local fetchedRolesList = GetGuildRoleList(guild)
        if fetchedRolesList[roleID2Check] then
			-- We found it in the current guild. Here you go!
	    	return tonumber(fetchedRolesList[roleID2Check])
		end
    end
    -- Okay, still no luck. Search Main guild for role by name (if main isn't current guild)
    if GetGuildId(guild) ~= tostring(Config.Guild_ID) then
    	local mainRolesList = GetGuildRoleList()
    	if mainRolesList[roleID2Check] then
        	-- We found it in the current guild. Here you go!
        	return tonumber(mainRolesList[roleID2Check])
      	end
    end
    -- Big oops, didn't find in current guild, or main guild. Search by name in all guilds!
    --[[
    -- Due to a security flaw in the below code, it was redacted for good reason...
    if (Config.Multiguild and not roleFound) then
      for guildName, guildID in pairs(Config.Guilds) do
        local thisRolesList = GetGuildRoleList(guildName)
        if thisRolesList[roleID2Check] then
          -- We found it in the current guild. Here you go!
          return tonumber(thisRolesList[roleID2Check])
        end
      end
    end
    ]]--
    return nil -- Sorry, couldn't find anywhere
end

function CheckEqual(role1, role2, guild --[[optional]])
    local roleID1 = FetchRoleID(role1, guild);
    local roleID2 = FetchRoleID(role2, guild);
	-- If they are the same exact name or ID & same type, they are equal
    if (type(roleID1) ~= "nil" and type(roleID2) ~= "nil") and roleID1 == roleID2 then
		return true
    end
	-- If they can be forced to number and they are the same ID, they are equal
    if ((tonumber(roleID1) ~= nil) and (tonumber(roleID1) == tonumber(roleID2))) then
        return true
    end

    return false
end

function IsDiscordEmailVerified(user) 
    local discordId = nil
    local isVerified = false;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                -- It is valid data 
                isVerified = data.verified;
            end
        else 
        	sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code]);
        end
    end
    return isVerified;
end

function GetDiscordEmail(user) 
    local discordId = nil
    local emailData = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                -- It is valid data 
                emailData = data.email;
            end
        else 
        	sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code])
        end
    end
    return emailData;
end

function GetDiscordName(user) 
    local discordId = nil
    local nameData = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
			-- It is valid data 
			if data.discriminator == 0 or data.discriminator == "0" then 
				return data.username 
			end			
				nameData = data.username .. "#" .. data.discriminator;
			end
		else 
			sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code])
		end
    end
    return nameData;
end

function GetGuildIcon(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		if (data.icon:sub(1, 1) and data.icon:sub(2, 2) == "_") then 
			-- It's a gif 
			return 'https://cdn.discordapp.com/icons/' .. Config.Guild_ID .. "/" .. data.icon .. ".gif";
		else 
			-- Image 
			return 'https://cdn.discordapp.com/icons/' .. Config.Guild_ID .. "/" .. data.icon .. ".png";
		end 
	else
		sendDebugMessage("[Badger_Discord_API] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildSplash(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return 'https://cdn.discordapp.com/splashes/' .. Config.Guild_ID .. "/" .. data.icon .. ".png";
	else
		sendDebugMessage("[Badger_Discord_API] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end 

function GetGuildName(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.name;
	else
		sendDebugMessage("[Badger_Discord_API] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildDescription(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.description;
	else
		sendDebugMessage("[Badger_Discord_API] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildMemberCount(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId.."?with_counts=true", {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.approximate_member_count;
	else
		sendDebugMessage("[Badger_Discord_API] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildOnlineMemberCount(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId.."?with_counts=true", {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		return data.approximate_presence_count;
	else
		sendDebugMessage("[Badger_Discord_API] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetDiscordAvatar(user) 
    local discordId = nil
    local imgURL = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
	end
	if discordId then 
		if Caches.Avatars[discordId] == nil then 
			local endpoint = ("users/%s"):format(discordId)
			local member = DiscordRequest("GET", endpoint, {})
			if member.code == 200 then
				local data = json.decode(member.data)
				if data ~= nil and data.avatar ~= nil then 
					-- It is valid data 
					if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
						imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif";
					else 
						imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
					end
				end
			else 
				sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code])
			end
			Caches.Avatars[discordId] = imgURL;
		else 
			imgURL = Caches.Avatars[discordId];
		end 
	else 
		sendDebugMessage("[Badger_Discord_API] ERROR: Discord ID was not found...")
	end
    return imgURL;
end

Caches = {
	Avatars = {},
  RoleList = {}
}
function ResetCaches()
	Caches = {
    Avatars = {},
    RoleList = {},
  };
end

function GetGuildRoleList(guild --[[optional]])
  local guildId = GetGuildId(guild)
	if (Caches.RoleList[guildId] == nil) then 
		local guild = DiscordRequest("GET", "guilds/"..guildId, {})
		if guild.code == 200 then
			local data = json.decode(guild.data)
			-- Image 
			local roles = data.roles;
			local roleList = {};
			for i = 1, #roles do 
				roleList[roles[i].name] = roles[i].id;
			end
			Caches.RoleList[guildId] = roleList;
		else
			sendDebugMessage("[Badger_Discord_API] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
			Caches.RoleList[guildId] = nil;
		end
	end
	return Caches.RoleList[guildId];
end

recent_role_cache = {}
function FindGuildForRole(roleId)
	local roleFound
	local tempGuildList = Config.Guilds
	tempGuildList["main_guild_abcd1010"] = Config.Guild_ID

  if not roleId then
    sendDebugMessage("[Badger_Discord_API] ERROR: Invalid usage of FindGuildForRole. Requires `roleId` arg.")
  end
  roleId = tostring(roleId)
	if roleGuilds[roleId] then
		return roleGuilds[roleId]
	end

	for _,id in pairs(tempGuildList) do
		local guild = DiscordRequest("GET", "guilds/"..id, {})
		if guild.code == 200 then
			local data = json.decode(guild.data)
			local roles = data.roles;
			for i = 1, #roles do
				if tostring(roles[i].id) == roleId then
					roleGuilds[roleId] = id
					roleFound = id
					break
				end
			end

			if roleFound then
				break
			end
		else
			sendDebugMessage("[Badger_Discord_API] ERROR: please check your config and ensure everything is correct. Error: "..tostring(guild.code))
		end
	end

	return roleFound
end

function RoleNameFromId(id, guild)
	local guildRoles = false
	local roleName

  if not id then
    sendDebugMessage("[Badger_Discord_API] ERROR: Invalid usage of RoleNameFromId. Requires `id` arg.")
    return roleName
  end
  id = tostring(id)
	if roleNames[id] then
		return roleNames[id]
	end
  if not guild then guild = FindGuildForRole(id) end
  if not guild then
    sendDebugMessage("[Badger_Discord_API] ERROR: RoleNameFromId could not find guild for role ["..id.."]")
  end
  guild = tostring(guild)
	guildRoles = GetGuildRoleList(guild)

	if guildRoles then
		for k, v in pairs(guildRoles) do
			if tostring(v) == id then
				roleNames[id] = k
				roleName = k
				break
			end
		end
	end
  if not roleName then
    sendDebugMessage("[Badger_Discord_API] ERROR: Could not find name for role ["..id.."] in guild ["..guild.."]")
  end
	return roleName
end

function ClearCache(discordId) 
	if (discordId ~= nil) then 
		recent_role_cache[discordId] = {};
	end
end

function GetDiscordRoles(user, guild --[[optional]])
  local discordId = nil
  local guildId = GetGuildId(guild)
  local roles = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break;
		end
	end

	if discordId then
		-- Get roles for specified guild (or main guild if not specified)
		roles = GetUserRolesInGuild(discordId, guildId)
		-- If specified guild or disabled multiguild option, just return this one
		if guild or Config.Multiguild == false then
			return roles
		end

		-- MULTIGUILD SECTION
		-- Keep main guild roles so we can add the rest on top of this list
		
		-- For some reason, referencing roles again will use the global reference that is returned...
		-- because of that, we use this resetRoles list and repopulate. Probably a better way to do this. -- Needs to be looked into
		resetRoles = {}
		for _, role_id in pairs(roles) do 
			table.insert(resetRoles, role_id);
		end
		roles = resetRoles
		local checkedGuilds = {}
		-- Loop through guilds in config and get the roles from each one.
		for _,id in pairs(Config.Guilds) do
			-- If it's the main guild, we already fetched these roles. NEXT!
			-- We don't really need this check, but maybe someone used their main guild in this config list....
			if tostring(id) == guildId then goto skip end
			if checkedGuilds[id] then goto skip end
			-- Fetch roles for this guild
			local guildRoles = GetUserRolesInGuild(discordId, id)
			checkedGuilds[id] = true
			-- If it didnt return false due to error, add the roles to the list
			if type(guildRoles) == "table" then
				-- Insert each role into roles list
				for _,v in pairs(guildRoles) do
					table.insert(roles, v)
				end
			end
			::skip::
		end
		return roles
	else
		sendDebugMessage("[Badger_Discord_API] ERROR: Discord was not connected to user's Fivem account...")
		return false
	end
	return false
end

function GetUserRolesInGuild (user, guild)
	-- Error check before starting operation
	if not user then
		sendDebugMessage("[Badger_Discord_API] ERROR: GetUserRolesInGuild requires discord ID")
		return false
	end
	if not guild then
		sendDebugMessage("[Badger_Discord_API] ERROR: GetUserRolesInGuild requires guild ID")
		return false
	end

	-- Check for cached roles
	if Config.CacheDiscordRoles and recent_role_cache[user] and recent_role_cache[user][guild] then
		return recent_role_cache[user][guild]
	end

	-- Request roles for user id
	local endpoint = ("guilds/%s/members/%s"):format(guild, user)
	local member = DiscordRequest("GET", endpoint, {})
	if member.code == 200 then
		local data = json.decode(member.data)
		local roles = data.roles
		if Config.CacheDiscordRoles then
			recent_role_cache[user] = recent_role_cache[user] or {}
			recent_role_cache[user][guild] = roles
			Citizen.SetTimeout(((Config.CacheDiscordRolesTime or 60)*1000), function() recent_role_cache[user][guild] = nil end)
		end
		return roles
	else
		sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached... Returning false. [Member Data NOT FOUND] DETAILS: " .. error_codes_defined[member.code])
		return false
	end
end

function GetDiscordNickname(user, guild --[[optional]])
  local discordId = nil
  local guildId = GetGuildId(guild)
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(guildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local nickname = data.nick
			return nickname;
		else
			sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. Error Code: " .. error_codes_defined[member.code])
			return nil;
		end
	else
		sendDebugMessage("[Badger_Discord_API] ERROR: Discord was not connected to user's Fivem account...")
		return nil;
	end
	return nil;
end

function SetNickname(user, nickname, reason)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, 'discord:') then
			discordId = string.gsub(id, 'discord:', '')
			break
		end
	end

	if discordId then
		local name = nickname or ""
		local endpoint = ("guilds/%s/members/%s"):format(Config.Guild_ID, discordId)
		local member = DiscordRequest("PATCH", endpoint, json.encode({nick = tostring(name)}), reason)
		if member.code ~= 200 and member.code ~= 204 then
			sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. Error Code: " .. error_codes_defined[member.code])
		end
	end
end

function AddRole(user, roleId, reason)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, 'discord:') then
			discordId = string.gsub(id, 'discord:', '')
			break
		end
	end

	if discordId then
		local roles = GetDiscordRoles(user) or {}
		local endpoint = ("guilds/%s/members/%s"):format(Config.Guild_ID, discordId)
		table.insert(roles, roleId)
		local member = DiscordRequest("PATCH", endpoint, json.encode({roles = roles}), reason)
		if member.code ~= 200 then
			sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. Error Code: " .. error_codes_defined[member.code])
		end
	end
end

function RemoveRole(user, roleId, reason)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, 'discord:') then
			discordId = string.gsub(id, 'discord:', '')
			break
		end
	end

	if discordId then
		local roles = GetDiscordRoles(user) or {}
		local endpoint = ("guilds/%s/members/%s"):format(Config.Guild_ID, discordId)

		for k, v in pairs(roles) do
			if v == roleId then
				roles[k] = nil
			end
		end

		local member = DiscordRequest("PATCH", endpoint, json.encode({roles = roles}), reason)
		if member.code ~= 200 then
			sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. Error Code: " .. error_codes_defined[member.code])
		end
	end
end

function SetRoles(user, roleList, reason)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, 'discord:') then
			discordId = string.gsub(id, 'discord:', '')
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.Guild_ID, discordId)
		local member = DiscordRequest("PATCH", endpoint, json.encode({roles = roleList}), reason)
		if member.code ~= 200 then
			sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. Error Code: " .. error_codes_defined[member.code])
		end
	end
end

function ChangeDiscordVoice(user, voice, reason)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.Guild_ID, discordId)
		local member = DiscordRequest("PATCH", endpoint, json.encode({channel_id = voice}), reason)
		if member.code ~= 200 then
			sendDebugMessage("[Badger_Discord_API] ERROR: Code 200 was not reached. Error Code: " .. error_codes_defined[member.code])
		end
	end
end

Citizen.CreateThread(function()
  local mguild = DiscordRequest("GET", "guilds/"..Config.Guild_ID, {})
  if mguild.code == 200 then
    local data = json.decode(mguild.data)
    sendDebugMessage("[Badger_Discord_API] Successful connection to Guild : "..data.name.." ("..data.id..")")
  else
    sendDebugMessage("[Badger_Discord_API] An error occured, please check your config and ensure everything is correct. Error: "..(mguild.data and json.decode(mguild.data) or mguild.code)) 
  end
  if (Config.Multiguild) then 
    for _,guildID in pairs(Config.Guilds) do
      local guild = DiscordRequest("GET", "guilds/"..guildID, {})
      if guild.code == 200 then
        local data = json.decode(guild.data)
        sendDebugMessage("[Badger_Discord_API] Successful connection to Guild : "..data.name.." ("..data.id..")")
      else
        sendDebugMessage("[Badger_Discord_API] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data and json.decode(guild.data) or guild.code)) 
      end
    end
  end
end)
