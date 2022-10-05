/**
 * Расширенные возможности чата для SourceMod 1.10+
 * Протестировано на CS:S OLD (v34), CS:S OB (Steam) и CS:GO
 * 
 * https://github.com/deathscore13/ChatModern
 */

#if defined _chat_modern_pl_included
 #endinput
#endif
#define _chat_modern_pl_included

#define PUBVAR_MAXCLIENTS

#include <sourcemod>
#include <sdktools>
#include <macros>

#include <chatmodern>

#define TV_CVAR 0   /**< sm_chatmodern_tv */
#define TV_SLOT 1   /**< Слот SourceTV */

#define BOT1    0   /**< Бот 1 */
#define BOT2    1   /**< Бот 2 */

int iBotsCV, iBots[2], iResource, iTeam[MAXPLAYERS + 1];
char sBotName[2][MAX_NAME_LENGTH];
bool bCREATE_EX(bBool, MAXPLAYERS + 1);
ConVar hCvar;

#define NOBOTS view_as<bool>(iTeam[0])

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
    if (!(NOBOTS = FindCommandLineParam("-nobots")))
    {
        (hCvar = CreateConVar("sm_chatmodern_bots", "2", "Количество добавляемых ботов для командного цвета, если на сервере менее 3-х игроков", _,
            true, 0.0, true, 2.0)).AddChangeHook(ConVarChanged_Bots);
        iBotsCV = hCvar.IntValue;

        (hCvar = CreateConVar("sm_chatmodern_name1", "DeathScore13", "Имя 1-го бота")).AddChangeHook(ConVarChanged_Name);
        hCvar.GetString(sz2(sBotName, BOT1));

        (hCvar = CreateConVar("sm_chatmodern_name2", "DeathScore133", "Имя 2-го бота")).AddChangeHook(ConVarChanged_Name);
        hCvar.GetString(sz2(sBotName, BOT2));
    }

    (hCvar = CreateConVar("sm_chatmodern_tv", "1", "Если tv_enable = 1 и SourceTV не появится после выполнения server.cfg, то карта \
        перезапустится (SourceTV тоже считается игроком)", _, true, 0.0, true, 1.0)).AddChangeHook(ConVarChanged_TV);
    bSET_EX(bBool, TV_CVAR, hCvar.BoolValue);

    hCvar = FindConVar("tv_enable");

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
    if (NOBOTS)
        PrintToServer("[ChatModern]: Bot settings disabled due to -nobots");
    else
        iBotsCV = convar.IntValue;
}

void ConVarChanged_Name(ConVar convar, const char[] oldValue, const char[] newValue)
{
    if (NOBOTS)
    {
        PrintToServer("[ChatModern]: Bot settings disabled due to -nobots");
    }
    else
    {
        char name[20];
        convar.GetName(sz(name));

        int team = StringToInt(name[18]) - 1;
        strcopy(sz2(sBotName, team), newValue);
    }
}

void ConVarChanged_TV(ConVar convar, const char[] oldValue, const char[] newValue)
{
    bSET_EX(bBool, TV_CVAR, convar.BoolValue);
}

Action EventHook_player_team(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"))
    if (client)
        iTeam[client] = event.GetInt("team");
}

public void OnConfigsExecuted()
{
    iResource = GetPlayerResourceEntity();
    if (hCvar.BoolValue && bGET_EX(bBool, TV_CVAR) && (!IsClientInGame(TV_SLOT) || !IsClientSourceTV(TV_SLOT)))
    {
        char map[PLATFORM_MAX_PATH];
        GetCurrentMap(sz(map));
        ServerCommand("map \"%s\"", map);
    }
}

public void OnClientPutInServer(int client)
{
    if (IsFakeClient(client))
    {
        if (iBots[BOT1] != client && iBots[BOT2] != client && 3 < GetClientCount(true))
        {
            if (iBots[BOT1])
                KickClient(iBots[BOT1]);
            else if (iBots[BOT2])
                KickClient(iBots[BOT2]);
        }
    }
    else
    {
        switch (GetClientCount(true))
        {
            case 1:
            {
                if (iBotsCV && !iBots[BOT1])
                {
                    iBots[BOT1] = GetNextSlot();
                    CreateFakeClient(sBotName[BOT1]);
                }

                if (iBotsCV == 2 && !iBots[BOT2])
                {
                    iBots[BOT2] = GetNextSlot();
                    CreateFakeClient(sBotName[BOT2]);
                }
            }
            case 2:
            {
                if (iBotsCV && !iBots[BOT1])
                {
                    iBots[BOT1] = GetNextSlot();
                    CreateFakeClient(sBotName[BOT1]);
                }
                else if (iBotsCV == 2 && !iBots[BOT2])
                {
                    iBots[BOT2] = GetNextSlot();
                    CreateFakeClient(sBotName[BOT2]);
                }
            }
            case 4:
            {
                if (iBots[BOT1])
                    KickClient(iBots[BOT1]);
                else if (iBots[BOT2])
                    KickClient(iBots[BOT2]);
            }
        }
    }
}

public void OnClientDisconnect(int client)
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
            {
                i = 0;
                break;
            }
        }

        if (i)
        {
            if (iBots[BOT1])
                KickClientEx(iBots[BOT1]);

            if (iBots[BOT2])
                KickClientEx(iBots[BOT2]);
            return;
        }

        switch (GetClientCount(true))
        {
            case 2:
            {
                if (iBotsCV && !iBots[BOT1])
                {
                    iBots[BOT1] = GetNextSlot();
                    CreateFakeClient(sBotName[BOT1]);
                }

                if (iBotsCV == 2 && !iBots[BOT2])
                {
                    iBots[BOT2] = GetNextSlot();
                    CreateFakeClient(sBotName[BOT2]);
                }
            }
            case 3:
            {
                if (iBotsCV && !iBots[BOT1])
                {
                    iBots[BOT1] = GetNextSlot();
                    CreateFakeClient(sBotName[BOT1]);
                }
                else if (iBotsCV == 2 && !iBots[BOT2])
                {
                    iBots[BOT2] = GetNextSlot();
                    CreateFakeClient(sBotName[BOT2]);
                }
            }
        }
    }
}

public void OnPluginEnd()
{
    if (iBots[BOT1])
        KickClientEx(iBots[BOT1]);

    if (iBots[BOT2])
        KickClientEx(iBots[BOT2]);
}

int GetNextSlot()
{
    int i;
    while (++i <= MaxClients)
        if (!IsClientConnected(i))
            return i;
    return 0;
}

#include "chatmodern_api"