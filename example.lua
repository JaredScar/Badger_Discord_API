-- IMPORTANT:
-- For use in other resources, you will need to use: 
--     exports.Badger_Discord_API:<function>
--
-- For example:
--		exports.Badger_Discord_API:GetRoleIdFromRoleName("roleName")

RegisterCommand('testResource', function(source, args, rawCommand)
	local user = source; -- The user 



-- function GetRoleIdFromRoleName(name)
-- Returns nil if not found
-- Returns Discord Role ID if found
-- Usage:
	local roleName = "Founder"; -- Change this to an existing role name on your Discord server 

	local roleID = GetRoleIdFromRoleName(roleName);
	print("[Badger_Perms Example] The roleID for (" .. roleName .. ") is: " .. tostring(roleID));

-- function IsDiscordEmailVerified(user)
-- Returns false if not found
-- Returns true if verified 
-- Usage:
	local isVerified = IsDiscordEmailVerified(user);
	print("[Badger_Perms Example] Player " .. GetPlayerName(user) .. " has Discord email verified?: " .. tostring(isVerified));

-- function GetDiscordEmail(user)
-- Returns nil if not found
-- Returns Email if found 
-- Usage:
	local emailAddr = GetDiscordEmail(user);
	print("[Badger_Perms Example] Player " .. GetPlayerName(user) .. " has Discord email address: " .. tostring(emailAddr));

-- function GetDiscordName(user)
-- Returns nil if not found
-- Returns Discord name if found 
-- Usage:
	local name = GetDiscordName(user);
	print("[Badger_Perms Example] Player " .. GetPlayerName(user) .. " has Discord name: " .. tostring(name));

-- function GetGuildIcon()
-- Returns nil if not found
-- Returns URL if found 
-- Usage:
	local icon_URL = GetGuildIcon();
	print("[Badger_Perms Example] Guild icon URL is: " .. tostring(icon_URL));

-- function GetGuildSplash()
-- Returns nil if not found
-- Returns URL if found 
-- Usage:
	local splash_URL = GetGuildSplash();
	print("[Badger_Perms Example] Guild splash URL is: " .. tostring(splash_URL));

-- function GetGuildName()
-- Returns nil if not found
-- Returns name if found 
-- Usage:
	local guildName = GetGuildName();
	print("[Badger_Perms Example] Guild name is: " .. tostring(guildName));

-- function GetGuildDescription()
-- Returns nil if not found
-- Returns description if found 
-- Usage:
	local guildDesc = GetGuildDescription();
	print("[Badger_Perms Example] Guild description is: " .. tostring(guildDesc));

-- function GetGuildMemberCount()
-- Returns nil if not found
-- Returns member count if found 
-- Usage:
	local guildMemCount = GetGuildMemberCount();
	print("[Badger_Perms Example] Guild member count is: " .. tostring(guildMemCount));

-- function GetGuildOnlineMemberCount()
-- Returns nil if not found
-- Returns description if found 
-- Usage:
	local onlineMemCount = GetGuildOnlineMemberCount();
	print("[Badger_Perms Example] Guild online member count is: " .. tostring(onlineMemCount));

-- function GetDiscordAvatar(user)
-- Returns nil if not found
-- Returns URL if found 
-- Usage:
	local avatar = GetDiscordAvatar(user);
	print("[Badger_Perms Example] Player " .. GetPlayerName(user) .. " has Discord avatar: " .. tostring(avatar));

-- function GetDiscordNickname(user)
-- Returns nil if not found
-- Returns nickname if found 
-- Usage:
	local nickname = GetDiscordNickname(user);
	print("[Badger_Perms Example] Player " .. GetPlayerName(user) .. " has Discord nickname: " .. tostring(nickname));

-- function GetGuildRoleList()
-- Returns nil if not found
-- Returns associative array if found 
-- Usage:
	local roles = GetGuildRoleList();
	for roleName, roleID in pairs(roles) do 
		print(roleName .. " === " .. roleID);
	end

-- function GetDiscordRoles(user)
-- Returns nil if not found
-- Returns array if found 
-- Usage:
	local roles = GetDiscordRoles(user)
	for i = 1, #roles do  
		print(roles[i]);
	end

-- function CheckEqual(role1, role2)
-- Returns false if not equal
-- Returns true if equal 
-- Usage:
	local isRolesEqual = CheckEqual("Founder", 597446100206616596);
	local isRolesEqual2 = CheckEqual("FounderRef", "Founder"); -- Refer to config.lua file, this is basically checking if FounderRef in the config is 
	-- equal to the Founder role's ID 

-- function SetNickname(user, nickname)
-- Returns error code 403 if the user is higher than the bot
-- Usage:
	SetNickname(user, "🦡Badger")
	SetNickname(user, "")
end)
