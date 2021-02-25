/**
 * =============================================================================
 *									Sht Include
 *  							All rights reserved.
 * =============================================================================
 *
 * Esta include é necessária para a compilação de todos os meus plugins.
 * Para dar compile é necessário usar #include <sht>
 *
 * Dúvidas? Xuap#3581
 * 
 */
 
#pragma newdecls optional

/**
 * Verifica se é jogador ou fake client
 *
 * @param client        Jogador
 * @return              Caso o valor for true é jogador, caso contrário é fake client.
 */
native bool IsValidClient(int client, bool bAllowBots = false, bool bAllowDead = true);

/** 
 * Verifica se o jogador está em jogo
 *
 * @param client        Jogador
 */
stock bool IsClientPlaying(int client)
{
	return IsClientInGame(client);
}

/** 
 * Verifica se o jogador tem certas flags
 *
 * @param client        Jogador
 * @param flags         Flag para verificar
 */
native bool HasClientFlag(int client, char[] flagString);
