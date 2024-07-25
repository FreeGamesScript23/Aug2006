local KeySystemUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/MaGiXxScripter0/keysystemv2api/master/ui/xrer_mstudio45.lua"))()
KeySystemUI.New({
    ApplicationName = "AshbornnHub", -- Your Key System Application Name
    Name = "AshbornnHub Lite", -- Your Script name
    Info = "Get Key For AshbornnHub Lite", -- Info text in the GUI, keep empty for default text.
    DiscordInvite = "https://discord.com/invite/kqV3wkQVWm", -- Optional.
    AuthType = "clientid" -- Can select verifycation with ClientId or IP ("clientid" or "ip")
})
repeat task.wait() until KeySystemUI.Finished() or KeySystemUI.Closed
if KeySystemUI.Finished() and KeySystemUI.Closed == false then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/LordRayven/UmF5dmVuScript/main/AshMainLite.lua",true))()
else
    print("Player closed the GUI.")
end
