Citizen.CreateThread(function()
    updatePath = "/JaredScar/Badger_Discord_API" -- your git user/repo path
    resourceName = "Badger_Discord_API ("..GetCurrentResourceName()..")" -- the resource name
    
    function checkVersion(err,responseText, headers)
        curVersion = LoadResourceFile(GetCurrentResourceName(), "version.txt") -- make sure the "version" file actually exists in your resource root!
    
        if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
            print("\n###############################")
            print("\n"..resourceName.." is outdated, should be: "..responseText.."\nis: "..curVersion.."\nplease update it from https://github.com"..updatePath.."")
            print("\n###############################")
        elseif tonumber(curVersion) > tonumber(responseText) then
            print("You somehow skipped a few versions of "..resourceName.." or the git went offline, if it's still online I advise you to update...")
        else
            print("\n"..resourceName.." is up to date!")
        end
    end
    
    PerformHttpRequest("https://raw.githubusercontent.com/JaredScar/Badger_Discord_API/main/version.txt", checkVersion, "GET")
end)