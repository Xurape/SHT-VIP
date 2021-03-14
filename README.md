# SHT-VIP

- A VIP plugin for CSGO servers. It has a lot of functions, from displaying info about the VIP, VIP Skills to some minor options which can be disabled.

# Features

[ Menus ]
- Perks
- Info about the VIP plans
- Settings Menu

[ Misc ]
- Full translatable
- Full personalizable
- Stores info of players on database
- Plays sounds on enabling options on perks

# Installation

1. Download the latest release from [here](https://github.com/ShutAP1337/SHT-VIP/releases/)
2. Create an entry on "addons/sourcemod/configs/databases.cfg" named "sht_vip"
```
"sht_vip"
{
	"driver"			"mysql"
	"host"				"your_mysql_ip"
	"database"			"your_mysql_database"
	"user"				"your_mysql_user"
	"pass"				"your_mysql_password"
}
```
3. Drop all the content inside the latest's release file on your server.
4. All done and ready to go.

# Cvars

* sm_sht_abrirmenuronda-> "1" - "1 - Opens Menu every round for VIP players when enabled. 0 - Do not open any menu."
* sm_sht_verificarmapa-> "0" - "1 - Verifies the map if it contains any gamemodes from CSGO Communities (awp_, de_, surf_) 0 - Do not verify the map and execute all configs."
* sm_sht_ativarhabilidades-> "1" - "1 - Enables the habilities menu. 0 - Disables"
* sm_sht_ativardefinicoes -> "1" - "1 - Enables the definitions menu. 0 - Disables"
* sm_sht_ativarinformacoes-> "1" - "1 - Enables the info menu. 0 - Disables"
* sm_sht_vip_habilidade_viprespawn-> "1" - "1 - Enables the VIP Respawn. 0 - Disables"
* sm_sht_vip_habilidade_multijump"-> "0" - "1 - Enables the Multijump. 0 - Disables"
* sm_sht_vip_habilidade_granadawallhack-> "1" - "1 - Enables the WH Grenade. 0 - Disables"
* sm_sht_vip_habilidade_granadaimpulsao-> "1" - "1 - Enables the Impulse Grenade. 0 - Disables"
* sm_sht_vip_habilidade_granadateleporte-> "1" - "1 - Enables the Teleport Grenade. 0 - Disables"
* sm_sht_vip_habilidade_seringaregeneracao-> "1" - "1 - Enables the Regeneration Serynge. 0 - Disables"
* sm_sht_ativarmensagens_hud -> "1", "1 - Enables the display of information on the HUD. 0 - Disables"
* sm_sht_ativarmensagens_chat -> "1", "1 - Enables the display of information on the Chat. 0 - Disables"
* sm_sht_mensagem_entrada -> "1", "1 - Enables the join message. 0 - Disables"
* sm_sht_vip_flag -> "a", "Flag to access the VIP menu."
* sm_scm_x -> "-1.0", "Horizontal Position to show the displayed message (To be centered, set as -1.0)."
* sm_scm_y -> "0.7", "Vertical Position to show the displayed message (To be centered, set as -1.0)."
* sm_scm_holdtime -> "2.0", "Time that the message is shown."
* sm_scm_r -> "255", "RGB Red Color to the displayed message."
* sm_scm_g -> "255", "RGB Green Color to the displayed message."
* sm_scm_b -> "255", "RGB Blue Color to the displayed message."
* sm_scm_transparency -> "100", "Message Transparency Value."
* sm_scm_effect -> "1.0", "0 - Fade In; 1 - Fade out; 2 - Flash"
* sm_scm_effectduration -> "0.5", "Duration of the selected effect. Not always aplicable"
* sm_scm_fadeinduration -> "0.5", "Duration of the selected effect."
* sm_scm_fadeoutduration -> "0.5", "Duration of the selected effect."

# Requirements (Extensions)

- [SteamWorks](http://users.alliedmods.net/~kyles/builds/SteamWorks/)
- [RipExt](https://github.com/ErikMinekus/sm-ripexts)

# Requirements (Only to compile)

[ External ]
- [MultiColors](https://github.com/Bara/Multi-Colors)
- [SteamWorks](https://github.com/KyleSanderson/SteamWorks/blob/master/Pawn/includes/SteamWorks.inc)
- [ENT_Emperor](https://github.com/Sples1/ENT_Emperor)
- [RipExt](https://github.com/ErikMinekus/sm-ripext)

[ Included in package ]
- [SHT](https://github.com/ShutAP1337/SHT-VIP/blob/main/addons/sourcemod/scripting/include/sht.inc)
- [SHT_Sons](https://github.com/ShutAP1337/SHT-VIP/blob/main/addons/sourcemod/scripting/include/sht_sons.inc)

**NOTE**: Every include is already on the "include" folder that comes within the version of the plugin, so no need to download them but I think it's always good to specify them!

# TODO

- ~~LIMIT PERK USAGE PER ROUND~~
- ~~LIMIT RESPAWN~~
- FIX VIP RESPAWN [Done but not tested!]
- ~~MAKE SETTINGS MENU~~
