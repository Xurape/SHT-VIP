stock const char BOTAO_1[] = 	"buttons/button1.wav";
stock const char BOTAO_2[] = 	"buttons/button2.wav";
stock const char BOTAO_3[] = 	"buttons/button3.wav";
stock const char BOTAO_4[] = 	"buttons/button4.wav";
stock const char BOTAO_5[] = 	"buttons/button5.wav";
stock const char BOTAO_6[] = 	"buttons/button6.wav";
stock const char BOTAO_7[] = 	"buttons/button7.wav";
stock const char BOTAO_8[] = 	"buttons/button8.wav";
stock const char BOTAO_9[] = 	"buttons/button9.wav";
stock const char BOTAO_10[] = 	"buttons/button10.wav";
stock const char BOTAO_11[] = 	"buttons/button11.wav";
stock const char BOTAO_12[] = 	"buttons/button12.wav";
stock const char BOTAO_13[] = 	"buttons/button13.wav";
stock const char BOTAO_14[] = 	"buttons/button14.wav";
stock const char BOTAO_15[] = 	"buttons/button15.wav";
stock const char BOTAO_16[] = 	"buttons/button16.wav";
stock const char BOTAO_17[] = 	"buttons/button17.wav";
stock const char BOTAO_18[] = 	"buttons/button18.wav";
stock const char BOTAO_19[] = 	"buttons/button19.wav";
stock const char RESPAWN[]  = 	"player/pl_respawn.wav";
stock const char HOME[] 	= 	"ui/panorama/mainmenu_press_home_01.wav";

void LoadSounds()
{
	PrecacheSound(BOTAO_1, true);
	PrecacheSound(BOTAO_2, true);
	PrecacheSound(BOTAO_3, true);
	PrecacheSound(BOTAO_4, true);
	PrecacheSound(BOTAO_5, true);
	PrecacheSound(BOTAO_6, true);
	PrecacheSound(BOTAO_7, true);
	PrecacheSound(BOTAO_8, true);
	PrecacheSound(BOTAO_9, true);
	PrecacheSound(BOTAO_10, true);
	PrecacheSound(BOTAO_11, true);
	PrecacheSound(BOTAO_12, true);
	PrecacheSound(BOTAO_13, true);
	PrecacheSound(BOTAO_14, true);
	PrecacheSound(BOTAO_15, true);
	PrecacheSound(BOTAO_16, true);
	PrecacheSound(BOTAO_17, true);
	PrecacheSound(BOTAO_18, true);
	PrecacheSound(BOTAO_19, true);
	PrecacheSound(RESPAWN, true);
	PrecacheSound(HOME, true);
}

void PlaySound(int iClient, const char[] szSound)
{
	ClientCommand(iClient, "playgamesound %s", szSound);
} 