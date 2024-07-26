local v1 = loadstring(game:HttpGet(("https://raw.githubusercontent.com/MaGiXxScripter0/keysystemv2api/master/ui/xrer_mstudio45.lua")))()
v1.New({
    ApplicationName = ("\65\115\104\98\111\114\110\110\72\117\98"),
    Name = ("\65\115\104\98\111\114\110\110\72\117\98"),
    Info = ("\71\101\116\32\75\101\121\32\70\111\114\32\65\115\104\98\111\114\110\110\72\117\98"),
    DiscordInvite = ("\104\116\116\112\115\58\47\47\100\105\115\99\111\114\100\46\99\111\109\47\105\110\118\105\116\101\47\107\113\86\51\119\107\81\86\87\109"),
    AuthType = ("\99\108\105\101\110\116\105\100")
})
repeat task.wait() until v1.Finished() or v1.Closed
if v1.Finished() and v1.Closed == false then
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/AshMain.lua"), true))()
else
    print(("\80\108\97\121\101\114\32\99\108\111\115\101\100\32\116\104\101\32\71\85\73\46"))
end
