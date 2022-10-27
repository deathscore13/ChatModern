/**
 * Расширенные возможности чата для SourceMod 1.10+
 * 
 * https://github.com/deathscore13/ChatModern
 */

#define PUBVAR_MAXCLIENTS

#include <sourcemod>
#include <sdktools>
#include <macros>

#include <chatmodern>

#define TV_CVAR 0   /**< sm_chatmodern_tv */

#define BOT1    0   /**< Бот 1 */
#define BOT2    1   /**< Бот 2 */

int iBotsCV, iBots[2], iResource, iTeam[MAXPLAYERS + 1];
char sBotName[2][MAX_NAME_LENGTH];
bool bCREATE_EX(bBool, MAXPLAYERS + 1);

#define BOTS_ENABLED view_as<bool>(iTeam[0])

#define bUSED_NULL() view_as<int>(bBool[0]) &= 1; \
    bBool[1] = false; \
    bBool[2] = false

#define bUSED_NOT_NULL() (view_as<int>(bBool[0]) >> 1 || bBool[1] || bBool[2])

public Plugin myinfo =
{
    name = "ChatModern",
    author = "DeathScore13",
    description = "Расширенные возможности чата для SourceMod 1.10+",
    version = "1.0.0",
    url = "https://github.com/deathscore13/ChatModern"
};

public void OnPluginStart()
{
    ConVar cvar;
    BOTS_ENABLED = !FindCommandLineParam("-nobots");

    (cvar = CreateConVar("sm_chatmodern_bots", "2", "Количество добавляемых ботов для командного цвета, если на сервере менее 3-х игроков",
        _, true, 0.0, true, 2.0)).AddChangeHook(ConVarChanged_Bots);
    if (BOTS_ENABLED)
        iBotsCV = cvar.IntValue;

    (cvar = CreateConVar("sm_chatmodern_name1", "DeathScore13", "Имя 1-го бота")).AddChangeHook(ConVarChanged_Name);
    if (BOTS_ENABLED)
        cvar.GetString(sz2(sBotName, BOT1));

    (cvar = CreateConVar("sm_chatmodern_name2", "DeathScore133", "Имя 2-го бота")).AddChangeHook(ConVarChanged_Name);
    if (BOTS_ENABLED)
        cvar.GetString(sz2(sBotName, BOT2));

    (cvar = CreateConVar("sm_chatmodern_tv", "1", "Если tv_enable = 1 и SourceTV не появится, то карта перезапустится \
        (SourceTV тоже считается игроком)", _, true, 0.0, true, 1.0)).AddChangeHook(ConVarChanged_TV);
    bSET_EX(bBool, TV_CVAR, cvar.BoolValue);

    (cvar = FindConVar("tv_enable")).AddChangeHook(ConVarChanged_tv_enable);
    ConVarChanged_tv_enable(cvar, NULL_STRING, NULL_STRING);

    AutoExecConfig(true, "chatmodern");
    HookEvent("player_team", EventHook_player_team);

    int i;
    while (++i <= MaxClients)
    {
        if (IsClientInGame(i))
        {
            OnClientPutInServer(i);
            iTeam[i] = GetClientTeam(i);
        }
    }
}

void ConVarChanged_Bots(ConVar convar, const char[] oldValue, const char[] newValue)
{
    if (BOTS_ENABLED)
    {
        iBotsCV = convar.IntValue;
    }
    else
    {
        PrintToServer("[ChatModern]: Bot settings disabled due to -nobots");
    }
}

void ConVarChanged_Name(ConVar convar, const char[] oldValue, const char[] newValue)
{
    if (BOTS_ENABLED)
    {
        char name[20];
        convar.GetName(sz(name));

        int team = StringToInt(name[18]) - 1;
        strcopy(sz2(sBotName, team), newValue);
    }
    else
    {
        PrintToServer("[ChatModern]: Bot settings disabled due to -nobots");
    }
}

void ConVarChanged_TV(ConVar convar, const char[] oldValue, const char[] newValue)
{
    bSET_EX(bBool, TV_CVAR, convar.BoolValue);
}

void ConVarChanged_tv_enable(ConVar convar, const char[] oldValue, const char[] newValue)
{
    if (convar.BoolValue && bGET_EX(bBool, TV_CVAR))
    {
        int i;
        while (++i <= MaxClients)
        {
            if (IsClientConnected(i) && IsClientSourceTV(i))
                break;
        }
        
        if (MaxClients < i)
        {
            char map[PLATFORM_MAX_PATH];
            GetCurrentMap(sz(map));
            ServerCommand("changelevel \"%s\"", map);
        }
    }
}

Action EventHook_player_team(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    if (client)
        iTeam[client] = event.GetInt("team");
}

public void OnMapStart()
{
    iResource = GetPlayerResourceEntity();
}

public void OnClientPutInServer(int client)
{
    RequestFrame(RF_OnClientPutInServer, GetClientUserId(client));
}

void RF_OnClientPutInServer(int userid)
{
    int client = GetClientOfUserId(userid);
    if (!client)
        return;
    
    if (IsFakeClient(client))
    {
        if (iBots[BOT1] != client && iBots[BOT2] != client && 3 < GetClientCount(true) &&
            !SafeKick(BOT1))
                SafeKick(BOT2);
    }
    else
    {
        switch (GetClientCount(true))
        {
            case 1:
            {
                if (iBotsCV && !iBots[BOT1])
                    iBots[BOT1] = CreateFakeClient(sBotName[BOT1]);

                if (iBotsCV == 2 && !iBots[BOT2])
                    iBots[BOT2] = CreateFakeClient(sBotName[BOT2]);
            }
            case 2:
            {
                if (iBotsCV && !iBots[BOT1])
                {
                    iBots[BOT1] = CreateFakeClient(sBotName[BOT1]);
                }
                else if (iBotsCV == 2 && !iBots[BOT2])
                {
                    iBots[BOT2] = CreateFakeClient(sBotName[BOT2]);
                }
            }
            case 4:
            {
                if (!SafeKick(BOT1))
                    SafeKick(BOT2);
            }
        }
    }
}

public void OnClientDisconnect_Post(int client)
{
    if (iBots[BOT1] == client)
    {
        iBots[BOT1] = 0;
    }
    else if (iBots[BOT2] == client)
    {
        iBots[BOT2] = 0;
    }
    else
    {
        int i;
        while (++i <= MaxClients)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
                break;
        }

        if (MaxClients < i)
        {
            SafeKick(BOT1);
            SafeKick(BOT2);
            
            return;
        }

        switch (GetClientCount(true))
        {
            case 1:
            {
                if (iBotsCV && !iBots[BOT1])
                    iBots[BOT1] = CreateFakeClient(sBotName[BOT1]);

                if (iBotsCV == 2 && !iBots[BOT2])
                    iBots[BOT2] = CreateFakeClient(sBotName[BOT2]);
            }
            case 2:
            {
                if (iBotsCV && !iBots[BOT1])
                {
                    iBots[BOT1] = CreateFakeClient(sBotName[BOT1]);
                }
                else if (iBotsCV == 2 && !iBots[BOT2])
                {
                    iBots[BOT2] = CreateFakeClient(sBotName[BOT2]);
                }
            }
        }
    }
}

public void OnPluginEnd()
{
    SafeKick(BOT1);
    SafeKick(BOT2);
}

bool SafeKick(int bot)
{
    if (iBots[bot])
    {
        if (IsClientConnected(iBots[bot]))
        {
            KickClientEx(iBots[bot]);
        }
        else
        {
            iBots[bot] = 0;
        }
        
        return true;
    }
    return false;
}
