/**
 * =============================================================================
 *									 Sht VIP
 *  							All rights reserved.
 * =============================================================================
 *
 * 			  VIP core plugin to CSGO servers, the modules will only work
 *	 						   with this core ative
 * 
 * =============================================================================
 */
 
/*TODO

- FAZER LIMITE DE SKILLS POR RONDA
- FAZER LIMITE DE RESPAWN
- DAR FIX AO RESPAWN
- FAZER MULTI JUMP
- FAZER INFORMAÇÕES
- FAZER DEFINIÇÕES

*/
 
// INCLUDES
#include <sourcemod>
#include <cstrike>
#include <multicolors>
#include <sdktools>
#include <sdkhooks>
#include <sht>
#include <steamworks>
#include <clientprefs>
#include <emperor>
#include <ripext>

// MODULOS
#include <sht_sons>

#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "0.6"

ConVar sht_abrirmenuronda;
ConVar sht_verificarmapa;

ConVar sht_ativarhabilidades;
ConVar sht_ativardefinicoes;
ConVar sht_ativarinformacoes;

ConVar sht_ativarmensagens_hud;
ConVar sht_ativarmensagens_chat;

ConVar sht_mensagementrada;

ConVar sht_vip_flag;

ConVar g_scm_cvar_holdtime;

ConVar g_scm_cvar_red;
ConVar g_scm_cvar_green;
ConVar g_scm_cvar_blue;
ConVar g_scm_cvar_transparency;

ConVar g_scm_cvar_x;
ConVar g_scm_cvar_y;

ConVar g_scm_cvar_effecttype;

ConVar g_scm_cvar_effectduration;
ConVar g_scm_cvar_fadeinduration;
ConVar g_scm_cvar_fadeoutduration;

ConVar sht_vip_habilidade_viprespawn;
ConVar sht_vip_habilidade_multijump;
ConVar sht_vip_habilidade_granadawallhack;
ConVar sht_vip_habilidade_granadaimpulsao;
ConVar sht_vip_habilidade_granadateleporte;
ConVar sht_vip_habilidade_seringaregeneracao;

float scm_holdtime;

bool sht_usou_menu[MAXPLAYERS] = false;
bool sht_spawn_ativo[MAXPLAYERS] = false;
bool sht_deu_revive[MAXPLAYERS+1] = false;

Handle VIP_HUD;
Handle sht_viprespawn_ativo;

char ServerIP[64];

HTTPClient httpClient;

public Plugin myinfo = 
{
	name = "VIP - Core",
	author = "ShutAP",
	description = "Plugin de menus VIP e módulos para VIP.",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/xurape"
};

public void OnPluginStart()
{
	// ConVars
	CreateConVar("sm_sht_vip_ver", PLUGIN_VERSION, "Plugin version // Do not touch!", FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);
	sht_abrirmenuronda = CreateConVar("sm_sht_abrirmenuronda", "1", "1 - Opens Menu every round for VIP players when enabled. 0 - Do not open any menu.");
	
	// UNDER DEVELOP.
	sht_verificarmapa = CreateConVar("sm_sht_verificarmapa", "0", "1 - Verifies the map if it contains any gamemodes from CSGO Communities (awp_, de_, surf_) 0 - Do not verify the map and execute all configs.");
	
	sht_ativarhabilidades = CreateConVar("sm_sht_ativarhabilidades", "1", "1 - Enables the habilities menu. 0 - Disables");
	sht_ativardefinicoes = CreateConVar("sm_sht_ativardefinicoes", "1", "1 - Enables the definitions menu. 0 - Disables");
	sht_ativarinformacoes = CreateConVar("sm_sht_ativarinformacoes", "1", "1 - Enables the info menu. 0 - Disables");
	
	sht_vip_habilidade_viprespawn = CreateConVar("sm_sht_vip_habilidade_viprespawn", "1", "1 - Enables the VIP Respawn. 0 - Disables");
	sht_vip_habilidade_multijump = CreateConVar("sm_sht_vip_habilidade_multijump", "0", "1 - Enables the Multijump. 0 - Disables");
	sht_vip_habilidade_granadawallhack = CreateConVar("sm_sht_vip_habilidade_granadawallhack", "1", "1 - Enables the WH Grenade. 0 - Disables");
	sht_vip_habilidade_granadaimpulsao = CreateConVar("sm_sht_vip_habilidade_granadaimpulsao", "1", "1 - Enables the Impulse Grenade. 0 - Disables");
	sht_vip_habilidade_granadateleporte = CreateConVar("sm_sht_vip_habilidade_granadateleporte", "1", "1 - Enables the Teleport Grenade. 0 - Disables");
	sht_vip_habilidade_seringaregeneracao = CreateConVar("sm_sht_vip_habilidade_seringaregeneracao", "1", "1 - Enables the Regeneration Serynge. 0 - Disables");
	
	sht_ativarmensagens_hud = CreateConVar("sm_sht_ativarmensagens_hud", "1", "1 - Enables the display of information on the HUD. 0 - Disables");
	sht_ativarmensagens_chat = CreateConVar("sm_sht_ativarmensagens_chat", "1", "1 - Enables the display of information on the Chat. 0 - Disables");
	
	sht_mensagementrada = CreateConVar("sm_sht_mensagem_entrada", "1", "1 - Enables the join message. 0 - Disables");
	
	sht_vip_flag = CreateConVar("sm_sht_vip_flag", "a", "Flag to access the VIP menu.");
	
	g_scm_cvar_x = CreateConVar("sm_scm_x", "-1.0", "Horizontal Position to show the displayed message (To be centered, set as -1.0).", _, true, -1.0, true, 1.0);
	g_scm_cvar_y = CreateConVar("sm_scm_y", "0.7", "Vertical Position to show the displayed message (To be centered, set as -1.0).", _, true, -1.0, true, 1.0);
	g_scm_cvar_holdtime = CreateConVar("sm_scm_holdtime", "2.0", "Time that the message is shown.", _, true, 0.0, true, 5.0);
	g_scm_cvar_red = CreateConVar("sm_scm_r", "255", "RGB Red Color to the displayed message.", _, true, 0.0, true, 255.0);
	g_scm_cvar_green = CreateConVar("sm_scm_g", "255", "RGB Green Color to the displayed message.", _, true, 0.0, true, 255.0);
	g_scm_cvar_blue = CreateConVar("sm_scm_b", "255", "RGB Blue Color to the displayed message.", _, true, 0.0, true, 255.0);
	g_scm_cvar_transparency = CreateConVar("sm_scm_transparency", "100", "Message Transparency Value.");	
	g_scm_cvar_effecttype = CreateConVar("sm_scm_effect", "1.0", "0 - Fade In; 1 - Fade out; 2 - Flash", _, true, 0.0, true, 2.0);
	g_scm_cvar_effectduration = CreateConVar("sm_scm_effectduration", "0.5", "Duration of the selected effect. Not always aplicable");
	g_scm_cvar_fadeinduration = CreateConVar("sm_scm_fadeinduration", "0.5", "Duration of the selected effect.");
	g_scm_cvar_fadeoutduration = CreateConVar("sm_scm_fadeoutduration", "0.5", "Duration of the selected effect.");	
	
	// Bolachas
	sht_viprespawn_ativo = RegClientCookie("vip_respawn", "VIP Respawn", CookieAccess_Private);
	
	VIP_HUD = CreateHudSynchronizer(); 

	// Commands
	RegConsoleCmd("sm_vip", MenuVIPInfo, "Open the VIP Info Menu.");
	RegConsoleCmd("sm_vipmenu", MenuVIP_Comando, "Open the VIP Menu with the advantages.");

	// Translations
	LoadTranslations("sht_vip.phrases");

	// Events
	HookEvent("round_start", InicioRonda);
	HookEvent("player_death", MorteVIP);
	HookEvent("decoy_firing", OnDecoyFiring);

	// Sons
	LoadSounds();

	// Verificar IP servidor & Plugin
	char serverip[32];
	int ips[4];
	int ip = GetConVarInt(FindConVar("hostip"));
	int port = GetConVarInt(FindConVar("hostport"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;

	Format(serverip, sizeof(serverip), "%d-%d-%d-%d:%d", ips[0], ips[1], ips[2], ips[3],port);
    //LogMessage(serverip);
	
	httpClient = new HTTPClient("https://catalyst.npdt.pt/api/");
	httpClient.Get(serverip, CheckIP);
	
	// Configs
	AutoExecConfig(true, "sht_vip", "sourcemod");
}

public void OnConfigsExecuted()
{
	// HUD Stuff
	scm_holdtime = GetConVarFloat(g_scm_cvar_holdtime);
	int scm_red = GetConVarInt(g_scm_cvar_red);
	int scm_green = GetConVarInt(g_scm_cvar_green);
	int scm_blue = GetConVarInt(g_scm_cvar_blue);
	int scm_transparency = GetConVarInt(g_scm_cvar_transparency);
	int scm_effect = GetConVarInt(g_scm_cvar_effecttype);
	float scm_x = GetConVarFloat(g_scm_cvar_x);
	float scm_y = GetConVarFloat(g_scm_cvar_y);
	float scm_effectduration = GetConVarFloat(g_scm_cvar_effectduration);
	float scm_fadein = GetConVarFloat(g_scm_cvar_fadeinduration);
	float scm_fadeout = GetConVarFloat(g_scm_cvar_fadeoutduration);
    
	SetHudTextParams(scm_x, scm_y, scm_holdtime, scm_red, scm_green, scm_blue, scm_transparency, scm_effect, scm_effectduration, scm_fadein, scm_fadeout);
	
	Handle request = CreateRequest_RequestIp();
	SteamWorks_SendHTTPRequest(request);
}

public void OnClientPostAdminCheck(int client)
{
	int mensagem_entrada = GetConVarInt(sht_mensagementrada);
	if(mensagem_entrada == 1) {
		MensagemDeEntrada(client);	
	}
}

void MensagemDeEntrada(int client)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			char flag[2];
			int flag_vip = EMP_Flag_StringToInt(flag);
			GetConVarString(sht_vip_flag, flag, sizeof(flag));
			if(Client_HasAdminFlags(client, flag_vip))
			{
				char traducao[256];
				char nome[MAX_NAME_LENGTH];
				GetClientName(client, nome, sizeof(nome));
				Format(traducao, sizeof(traducao), "%t", "VIP_Saida", nome);
				CPrintToChat(i, traducao);
			}
		}
	}
}

public void OnDecoyFiring(Event event, const char[] name, bool dontBroadcast)
{
	int userid = GetEventInt(event, "userid");
	int client = GetClientOfUserId(userid);

	float f_Pos[3];
	int entityid = GetEventInt(event, "entityid");
	f_Pos[0] = GetEventFloat(event, "x");
	f_Pos[1] = GetEventFloat(event, "y");
	f_Pos[2] = GetEventFloat(event, "z");

	TeleportEntity(client, f_Pos, NULL_VECTOR, NULL_VECTOR);
	RemoveEdict(entityid);
}

public Action InicioRonda(Event event, const char[] name, bool dontBroadcast)
{
    for(int i = 1; i <= MaxClients; i++)
	{
		sht_deu_revive[i] = false;
		sht_usou_menu[i] = false;
		char flag[2];
		GetConVarString(sht_vip_flag, flag, sizeof(flag));
		int flag_vip = EMP_Flag_StringToInt(flag);
		int sht_menuronda = GetConVarInt(sht_abrirmenuronda);
		if(sht_menuronda == 0) {
			if(EMP_IsValidClient(i) && Client_HasAdminFlags(i, flag_vip)) {
				MenuVIP_Menu(i);
			} 
		}
    }
}


public Action MenuVIP_Comando(int client, int args) 
{
	char flag[2];
	char traducao[255];
	int flag_vip = EMP_Flag_StringToInt(flag);
	
	GetConVarString(sht_vip_flag, flag, sizeof(flag));
	
	if(EMP_IsValidClient(client) && Client_HasAdminFlags(client, flag_vip)) {
		if(IsPlayerAlive(client)) {
			MenuVIP_Menu(client);
		} else {
			Format(traducao, sizeof(traducao), "%t", "Nao_vivo");
			CPrintToChat(client, traducao);
		}
	} 
	
	return Plugin_Handled;
}

public Action MenuVIP_Geral(int client, int args) 
{
	for (int i = 1; i <= MaxClients; i++)
	{
		char flag[2];
		GetConVarString(sht_vip_flag, flag, sizeof(flag));
		int flag_vip = EMP_Flag_StringToInt(flag);
		if(EMP_IsValidClient(i) && Client_HasAdminFlags(i, flag_vip)) {
			MenuVIP_Menu(i);
		}
	}
	
	return Plugin_Handled;
}


public Action MenuVIPInfo(int client, int args) 
{
	char traducao[256];
	char flag[2];
	char jogador_nome[64];
	
	int habilidades = GetConVarInt(sht_ativarhabilidades);
	int informacoes = GetConVarInt(sht_ativarinformacoes);
	int definicoes = GetConVarInt(sht_ativardefinicoes);
	int flag_vip = EMP_Flag_StringToInt(flag);

	Menu menuvip_info_menu = new Menu(MenuVIPInfoHNDL);

	GetConVarString(sht_vip_flag, flag, sizeof(flag));
	GetClientName(client, jogador_nome, sizeof(jogador_nome));

	Format(traducao, sizeof(traducao), "%t", "menuvip_titulo", jogador_nome);
	menuvip_info_menu.SetTitle(traducao);
	
	if(habilidades == 1) {
		int vermapas = GetConVarInt(sht_verificarmapa);
		if(vermapas == 1) 
		{
			char nomedomapa[128];
			GetCurrentMap(nomedomapa, sizeof(nomedomapa));
			if(StrContains(nomedomapa, "de_")) {
				char modo_de_jogo[32];
				Format(modo_de_jogo, sizeof(modo_de_jogo), "Competitivo");
				
				Format(traducao, sizeof(traducao), "%t", "habilidades");
				menuvip_info_menu.AddItem("habilidades", traducao, ITEMDRAW_DISABLED);			
			} else {
				Format(traducao, sizeof(traducao), "%t", "habilidades");
				menuvip_info_menu.AddItem("habilidades", traducao, (Client_HasAdminFlags(client, flag_vip)) ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);			
			}
		} else {
			Format(traducao, sizeof(traducao), "%t", "habilidades");
			menuvip_info_menu.AddItem("habilidades", traducao, (Client_HasAdminFlags(client, flag_vip)) ? ITEMDRAW_DEFAULT : ITEMDRAW_DISABLED);			
		}
    }
	
	if(informacoes == 1) {
		Format(traducao, sizeof(traducao), "%t", "informacoes");
		menuvip_info_menu.AddItem("informacoes", traducao);	
	}
	
	if(definicoes == 1) {
		Format(traducao, sizeof(traducao), "%t", "definicoes");
		menuvip_info_menu.AddItem("definicoes", traducao);
	}
	
	menuvip_info_menu.Display(client, 30);
	
	return Plugin_Handled;
}



public int MenuVIPInfoHNDL(Menu MenuVIPmenu, MenuAction action, int client, int position)
{
	if (action == MenuAction_Select) {
		char item[64];
		MenuVIPmenu.GetItem(position, item, sizeof(item));
		

		if(StrEqual(item, "habilidades")) 
		{
			MenuVIP_Menu(client);
		} 
		if(StrEqual(item, "informacoes")) 
		{
			MenuVIP_Informacoes(client);
		} 
		if(StrEqual(item, "definicoes")) 
		{
			//MenuVIP_Definicoes(client);
		} 
	} else if (action == MenuAction_End) {
		delete MenuVIPmenu;
	}
}

public Menu MenuVIP_Menu(int client)
{
	sht_usou_menu[client] = true;
	char traducao[256];
	Menu MenuVIPmenu = new Menu(MenuVIPmenuHandler);
	
	int h_viprespawn = GetConVarInt(sht_vip_habilidade_viprespawn);
	int h_multijump = GetConVarInt(sht_vip_habilidade_multijump);
	int h_granadawallhack = GetConVarInt(sht_vip_habilidade_granadawallhack);
	int h_granadaimpulsao = GetConVarInt(sht_vip_habilidade_granadaimpulsao);
	int h_granadateleporte = GetConVarInt(sht_vip_habilidade_granadateleporte);
	int h_seringaregeneracao = GetConVarInt(sht_vip_habilidade_seringaregeneracao);
	
	
	char nomepl[20];
	GetClientName(client, nomepl, sizeof(nomepl));
	Format(traducao, sizeof(traducao), "%t", "menuvip_titulo", nomepl);
	MenuVIPmenu.SetTitle(traducao);
	
	if(h_viprespawn == 1) {
		char bolacha[64];
		GetClientCookie(client, sht_viprespawn_ativo, bolacha, sizeof(bolacha));
		int bolachavalor = StringToInt(bolacha);
		if(bolachavalor == 1) {
			Format(traducao, sizeof(traducao), "%t", "viprespawn_enable");
			MenuVIPmenu.AddItem("viprespawn_enable", traducao);
		}
		else {
			Format(traducao, sizeof(traducao), "%t", "viprespawn");
			MenuVIPmenu.AddItem("viprespawn", traducao);
		}
	}
	if(h_multijump == 1) 
	{
		Format(traducao, sizeof(traducao), "%t", "multijump");
		MenuVIPmenu.AddItem("multijump", traducao);	
	} 
	if(h_granadawallhack)
	{
		Format(traducao, sizeof(traducao), "%t", "granada_wallhack");
		MenuVIPmenu.AddItem("granada_wallhack", traducao);
	}
	if(h_granadaimpulsao == 1)
	{
		Format(traducao, sizeof(traducao), "%t", "granada_impulso");
		MenuVIPmenu.AddItem("granada_impulso", traducao);
	}	
	if(h_granadateleporte == 1)
	{
		Format(traducao, sizeof(traducao), "%t", "granada_teleport");
		MenuVIPmenu.AddItem("granada_teleport", traducao);
	}	
	if(h_seringaregeneracao == 1)
	{
		Format(traducao, sizeof(traducao), "%t", "seringa_regen");
		MenuVIPmenu.AddItem("seringa_regen", traducao);
	}	
	MenuVIPmenu.Display(client, 30);
	return MenuVIPmenu;
}


public int MenuVIPmenuHandler(Menu MenuVIPmenu, MenuAction action, int client, int position)
{
	if (action == MenuAction_Select) {
		char item[64];
		char traducao[255];
		char traducao_hud[255];
		int hud_ativo = GetConVarInt(sht_ativarmensagens_hud);
		int chat_ativo = GetConVarInt(sht_ativarmensagens_chat);
		
		
		MenuVIPmenu.GetItem(position, item, sizeof(item));
		if(StrEqual(item, "viprespawn")) 
		{
			Format(traducao, sizeof(traducao), "%t", "VIPRespawn_Ativo");
			if(chat_ativo == 1) {
				CPrintToChat(client, traducao);
			}
			if(hud_ativo == 1) {
				Format(traducao_hud, sizeof(traducao_hud), "%t VIP Respawn.", "HUD_HabilidadeUsada");
				ShowSyncHudText(client, VIP_HUD, traducao_hud); 
			}
			sht_spawn_ativo[client] = true;
			SetClientCookie(client, sht_viprespawn_ativo, "1");
			PlaySound(client, RESPAWN);
			delete MenuVIPmenu;
			MenuVIP_Menu(client);
		}
		if(StrEqual(item, "viprespawn_enable")) 
		{
			Format(traducao, sizeof(traducao), "%t", "VIPRespawn_Desativado");
			if(chat_ativo == 1) {
				CPrintToChat(client, traducao);
			}
			if(hud_ativo == 1) {
				Format(traducao_hud, sizeof(traducao_hud), "%t %t", "HUD_HabilidadeDesativada", "s_viprespawn");
				ShowSyncHudText(client, VIP_HUD, traducao_hud); 
			}
			sht_spawn_ativo[client] = false;
			SetClientCookie(client, sht_viprespawn_ativo, "0");
			char bolacha[64];
			GetClientCookie(client, sht_viprespawn_ativo, bolacha, sizeof(bolacha));
			PlaySound(client, HOME);
			delete MenuVIPmenu;
			MenuVIP_Menu(client);
		} 
		if(StrEqual(item, "multijump")) 
		{
			FakeClientCommand(client, "multijump");
			delete MenuVIPmenu;
		} 
		if(StrEqual(item, "granada_wallhack")) 
		{
			Format(traducao, sizeof(traducao), "%t", "GranadaWH_dada");
			GivePlayerItem(client, "weapon_tagrenade");
			if(chat_ativo == 1) {
				CPrintToChat(client, traducao);
			}
			if(hud_ativo == 1) {
				Format(traducao_hud, sizeof(traducao_hud), "%t %t", "HUD_HabilidadeUsada", "s_granada_wallhack");
				ShowSyncHudText(client, VIP_HUD, traducao_hud); 
			}
			delete MenuVIPmenu;
		} 
		if(StrEqual(item, "granada_impulso")) 
		{
			Format(traducao, sizeof(traducao), "%t", "GranadaImpulso_dada");
			if(chat_ativo == 1) {
				CPrintToChat(client, traducao);
			}
			if(hud_ativo == 1) {
				Format(traducao_hud, sizeof(traducao_hud), "%t %t", "HUD_HabilidadeUsada", "s_granada_impulso");
				ShowSyncHudText(client, VIP_HUD, traducao_hud); 
			}
			GivePlayerItem(client, "weapon_bumpmine");
			delete MenuVIPmenu;
		} 
		if(StrEqual(item, "granada_teleport")) 
		{
			Format(traducao, sizeof(traducao), "%t", "GranadaTP_dada");
			if(chat_ativo == 1) {
				CPrintToChat(client, traducao);
			}
			if(hud_ativo == 1) {
				Format(traducao_hud, sizeof(traducao_hud), "%t %t", "HUD_HabilidadeUsada", "s_granada_teleport");
				ShowSyncHudText(client, VIP_HUD, traducao_hud); 
			}
			GivePlayerItem(client, "weapon_decoy");
			delete MenuVIPmenu;
		} 
		if(StrEqual(item, "seringa_regen")) 
		{
			Format(traducao, sizeof(traducao), "%t", "SeringaRegen_dada");
			if(chat_ativo == 1) {
				CPrintToChat(client, traducao);
			}
			if(hud_ativo == 1) {
				Format(traducao_hud, sizeof(traducao_hud), "%t %t", "HUD_HabilidadeUsada", "s_seringa_regen");
				ShowSyncHudText(client, VIP_HUD, traducao_hud); 
			}
			GivePlayerItem(client, "weapon_healthshot");
			delete MenuVIPmenu;
		} 
	} else if (action == MenuAction_End) {
		MenuVIPInfo(client, client);
	}
}

public Menu MenuVIP_Informacoes(int client)
{
	char traducao[256];
	char nomepl[20];
	
	Menu MenuVIPmenu_Infor = new Menu(MenuVIP_InformacoesHandler);

	GetClientName(client, nomepl, sizeof(nomepl));
	Format(traducao, sizeof(traducao), "%t", "menuvip_titulo", nomepl);
	
	MenuVIPmenu_Infor.SetTitle(traducao);
	
	Format(traducao, sizeof(traducao), "%t", "linha1");
	MenuVIPmenu_Infor.AddItem("linha1", traducao);//, ITEMDRAW_DISABLED);
	
	Format(traducao, sizeof(traducao), "%t", "linha2");
	MenuVIPmenu_Infor.AddItem("linha2", traducao);//, ITEMDRAW_DISABLED);
	
	Format(traducao, sizeof(traducao), "%t", "linha3");
	MenuVIPmenu_Infor.AddItem("linha3", traducao);//, ITEMDRAW_DISABLED);
	
	Format(traducao, sizeof(traducao), "%t", "linha4");
	MenuVIPmenu_Infor.AddItem("linha4", traducao);//, ITEMDRAW_DISABLED);
	
	Format(traducao, sizeof(traducao), "%t", "linha5");
	MenuVIPmenu_Infor.AddItem("linha5", traducao);//, ITEMDRAW_DISABLED);
		
	MenuVIPmenu_Infor.Display(client, 30);
	return MenuVIPmenu_Infor;
}


public int MenuVIP_InformacoesHandler(Menu MenuVIPmenu_Infor, MenuAction action, int client, int position)
{
	if (action == MenuAction_Select) {
		MenuVIPInfo(client, client);
	} else if (action == MenuAction_End) {
		MenuVIPInfo(client, client);
	}
}


public Action MorteVIP(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(sht_spawn_ativo[client] == true) {
		CreateTimer(2.0, Respawn_Player, client);
		sht_spawn_ativo[client] = false;
		sht_deu_revive[client] = true;
	}
}

public Action Respawn_Player(Handle iTimer, int client)
{
	CS_RespawnPlayer(client);
	char traducao[255];
	Format(traducao, sizeof(traducao), "%t", "VIPSpawn_Respawn");
}

///////////////////////////
//
//
//     VERIFICAR IP
//
//
//////////////////////////

public Handle CreateRequest_RequestIp()
{
    char request_url[512];
    
    FormatEx(request_url, sizeof(request_url), "https://ip.seeip.org/jsonip?");
    Handle request = SteamWorks_CreateHTTPRequest(k_EHTTPMethodGET, request_url);
    
    int client = 0;
    SteamWorks_SetHTTPRequestContextValue(request, client);
    SteamWorks_SetHTTPCallbacks(request, RequestIp_OnHTTPResponse);
    return request;
}

public int RequestIp_OnHTTPResponse(Handle request, bool bFailure, bool bRequestSuccessful, EHTTPStatusCode eStatusCode, int client)
{
    if (!bRequestSuccessful || eStatusCode != k_EHTTPStatusCode200OK)
    {
        delete request;
        return;
    }
    
    int bufferSize;

    SteamWorks_GetHTTPResponseBodySize(request, bufferSize);

    char[] responseBody = new char[bufferSize];
    SteamWorks_GetHTTPResponseBodyData(request, responseBody, bufferSize);
    delete request;

    if (strlen(responseBody) > 0)
    {
        TrimString(responseBody);
        ReplaceString(responseBody, bufferSize, "{\"ip\":\"", "");
        ReplaceString(responseBody, bufferSize, "\"}", "");
    
        int Port = GetConVarInt(FindConVar("hostport"));
        FormatEx(ServerIP, sizeof(ServerIP), "%s:%d", responseBody, Port);
    }
}

void CheckIP(HTTPResponse response, any value)
{
    if (response.Status != HTTPStatus_OK) {
        return;
    }

    JSONObject api = view_as<JSONObject>(response.Data);

    char autorizacao[256];
    api.GetString("autorizado", autorizacao, sizeof(autorizacao));
    
    if (StrEqual(autorizacao, "Autorizado"))
	{
		PrintToServer("SHT VIP - This plugin is authorized on this server. GREAT!");
   	}
   	else if (StrEqual(autorizacao, "Banido"))
	{
		PrintToServer("SHT VIP - This plugin was banned from this server!");
		SetFailState("This plugin is banned on this server.");
   	}
	else
    {
   		PrintToServer("SHT VIP - This plugin is unauthorized on this server.");
		SetFailState("This plugin is unauthorized on this server.");
    }

} 