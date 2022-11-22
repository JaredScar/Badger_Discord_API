# Badger_Discord_API

## Visitor Count
  <img src="https://profile-counter.glitch.me/Badger_Discord_API/count.svg" />

## Documentation
[Installation Guide](https://docs.badger.store/fivem-discord-scripts/badger_discord_api/installation-script)

[API Development/ Implementation Docs](https://docs.badger.store/fivem-discord-scripts/badger_discord_api)

## Jared's Developer Community [Discord]
[![Developer Discord](https://discordapp.com/api/guilds/597445834153525298/widget.png?style=banner4)](https://discord.com/invite/WjB5VFz)

## Sponsors
### <a href='https://github.com/sponsors/JaredScar?frequency=one-time&sponsor=JaredScar' target='_blank'>Want your message here?</a>
| Sponsor | Sponsor Message |
| --- | --- |
| <a href="https://github.com/JawshTheDark" target='_blank'><img height='50' width='50' src='https://avatars.githubusercontent.com/u/8483260?v=4' /></a> | Sponsored by North American Roleplaying Community - NARC <br /> <p align='center'>Visit us @ https://discord.gg/NARC</p> |
| <a href='https://github.com/Legacy-TacticalGamingInteractive' target='_blank'><img height='50' width='50' src='https://avatars.githubusercontent.com/u/25211271?v=4' /></a> | <a href="https://discord.gg/eots" target='_blank'><p align='center'>Enemy of the State Roleplay</p></a>

## Notes
Some methods of the API not may fully work or be broken. I was able to test most and 75% of it works. If something does not work, please just submit an issue or pull request for it on the GitHub page. I will be making a more reinforced documentation for this whole API sometime in the future, but for now please just make use of the example.lua file for understanding it all. Thanks!

## What is it?
This is essentially a Discord API for FiveM. It utilizes the REST API of Discord for all your essential needs :) Things that are heavy in Discord rate limiting (such as retreiving all server roles and player avatars) will be automatically stored to a cache for developers automatically. I will be moving all my scripts over to use this API for better ease of use. Some features include not having to gather role IDs at all, since the script gets the server's roles automatically, so you can just specify the role's name instead of role IDs at all (however, be aware that this will break then if someone changes the roles' names on Discord)... I hope you can all find some use for this, I know I will :P

## Scripts that utilize the API
https://forum.cfx.re/t/release-badgertools-major-revamp/665756/
https://forum.cfx.re/t/discordaceperms-release/573044
https://forum.cfx.re/t/release-bad-discordqueue-a-discord-role-based-queue-system-by-badger/1394685
https://forum.cfx.re/t/discordtagids-i-know-i-know-i-only-make-discord-based-scripts/582513
https://forum.cfx.re/t/discordchatroles-release/566338

## Example Usage:

```
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
```

## Download

https://github.com/JaredScar/Badger_Discord_API
