local FormattedToken = "Bot " .. Config.Bot_Token

Citizen.CreateThread(function()
	print("[" .. GetCurrentResourceName() .. "] " .. "IMPORTANT: This resource must be named Badger_Discord_API for it to work properly with other scripts...");
	if (GetCurrentResourceName() ~= "Badger_Discord_API") then 
		StopResource(GetCurrentResourceName());
	end
end)

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function GetRoleIdFromRoleName(name)
	if (Caches.RoleList ~= nil) then 
		return tonumber(Caches.RoleList[name]);
	else 
		local roles = GetGuildRoleList();
		return tonumber(roles[name]);
	end
end

function CheckEqual(role1, role2)
	local checkStr1 = false;
	local checkStr2 = false;
	local roleID1 = role1;
	local roleID2 = role2;
	if type(role1) == "string" then checkStr1 = true end;
	if type(role2) == "string" then checkStr2 = true end; 
	if checkStr1 then 
		local roles = GetGuildRoleList();
		for roleName, roleID in pairs(roles) do 
			if roleName == role1 then 
				roleID1 = roleID;
			end
		end
		local roles2 = Config.RoleList;
		for roleRef, roleID in pairs(roles2) do 
			if roleRef == role1 then 
				roleID1 = roleID;
			end
		end
	end
	if checkStr2 then 
		local roles = GetGuildRoleList();
		for roleName, roleID in pairs(roles) do 
			if roleName == role2 then 
				roleID2 = roleID;
			end
		end
		local roles2 = Config.RoleList;
		for roleRef, roleID in pairs(roles2) do 
			if roleRef == role2 then 
				roleID2 = roleID;
			end
		end
	end
	if tonumber(roleID1) == tonumber(roleID2) then 
		return true;
	end
	return false;
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
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                isVerified = data.verified;
                --print("---")
            end
        else 
        	print("[Badger_Perms] ERROR: Code 200 was not reached. Error provided: " .. member.data)
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
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                emailData = data.email;
                --print("---")
            end
        else 
        	print("[Badger_Perms] ERROR: Code 200 was not reached. Error provided: " .. member.data)
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
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                nameData = data.username .. "#" .. data.discriminator;
                --print("---")
            end
        else 
        	print("[Badger_Perms] ERROR: Code 200 was not reached. Error provided: " .. member.data)
        end
    end
    return nameData;
end

function GetGuildIcon()
	local guild = DiscordRequest("GET", "guilds/"..Config.Guild_ID, {})
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
		print("[Badger_Perms] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildSplash()
	local guild = DiscordRequest("GET", "guilds/"..Config.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return 'https://cdn.discordapp.com/splashes/' .. Config.Guild_ID .. "/" .. data.icon .. ".png";
	else
		print("[Badger_Perms] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end 

function GetGuildName()
	local guild = DiscordRequest("GET", "guilds/"..Config.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.name;
	else
		print("[Badger_Perms] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildDescription()
	local guild = DiscordRequest("GET", "guilds/"..Config.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.description;
	else
		print("[Badger_Perms] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildMemberCount()
	local guild = DiscordRequest("GET", "guilds/"..Config.Guild_ID.."?with_counts=true", {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.approximate_member_count;
	else
		print("[Badger_Perms] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildOnlineMemberCount()
	local guild = DiscordRequest("GET", "guilds/"..Config.Guild_ID.."?with_counts=true", {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		return data.approximate_presence_count;
	else
		print("[Badger_Perms] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
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
					--print("The data for User " .. GetPlayerName(user) .. " is: ");
					--print(data.avatar);
					if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
						--print("IMG URL: " .. "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif")
						imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif";
					else 
						--print("IMG URL: " .. "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png")
						imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
					end
					--print("---")
				end
			else 
				print("[Badger_Perms] ERROR: Code 200 was not reached. Error provided: " .. member.data)
			end
			Caches.Avatars[discordId] = imgURL;
		else 
			imgURL = Caches.Avatars[discordId];
		end 
	else 
		print("[Badger_Perms] ERROR: Discord ID was not found...")
	end
    return imgURL;
end

Caches = {
	Avatars = {}
}
function ResetCaches()
	Caches = {};
end

function GetGuildRoleList()
	if (Caches.RoleList == nil) then 
		local guild = DiscordRequest("GET", "guilds/"..Config.Guild_ID, {})
		if guild.code == 200 then
			local data = json.decode(guild.data)
			-- Image 
			local roles = data.roles;
			local roleList = {};
			for i = 1, #roles do 
				roleList[roles[i].name] = roles[i].id;
			end
			Caches.RoleList = roleList;
		else
			print("[Badger_Perms] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
			Caches.RoleList = nil;
		end
	end
	return Caches.RoleList;
end

function GetDiscordRoles(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break;
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.Guild_ID, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			return roles
		else
			print("[Badger_Perms] ERROR: Code 200 was not reached... Returning false. [Member Data NOT FOUND]")
			return false
		end
	else
		print("[Badger_Perms] ERROR: Discord was not connected to user's Fivem account...")
		return false
	end
	return false
end

function GetDiscordNickname(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.Guild_ID, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local nickname = data.nick
			return nickname;
		else
			print("[Badger_Perms] ERROR: Code 200 was not reached. Error provided: "..member.data)
			return nil;
		end
	else
		print("[Badger_Perms] ERROR: Discord was not connected to user's Fivem account...")
		return nil;
	end
	return nil;
end

Citizen.CreateThread(function()
	local guild = DiscordRequest("GET", "guilds/"..Config.Guild_ID, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		print("[Badger_Perms] Permission system guild set to: "..data.name.." ("..data.id..")")
	else
		print("[Badger_Perms] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
end)