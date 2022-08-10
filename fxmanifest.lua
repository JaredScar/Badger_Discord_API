fx_version 'cerulean'
game 'gta5'

author 'JaredScar'
description 'Badger\'s Discord API'
version '1.6'
url 'https://github.com/JaredScar/Badger_Discord_API'

client_scripts {
	'client.lua',
}

server_scripts {
	'config.lua',
	"server.lua", -- Uncomment this line
	--"example.lua" -- Remove this when you actually start using the script!!!
}

server_exports { 
	"GetDiscordRoles",
	"GetRoleIdFromRoleName",
	"GetDiscordAvatar",
	"GetDiscordName",
	"GetDiscordEmail",
	"IsDiscordEmailVerified",
	"GetDiscordNickname",
	"GetGuildIcon",
	"GetGuildSplash",
	"GetGuildName",
	"GetGuildDescription",
	"GetGuildMemberCount",
	"GetGuildOnlineMemberCount",
	"GetGuildRoleList",
	"ResetCaches",
	"CheckEqual",
	"SetNickname"
} 
