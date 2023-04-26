UserMsg iTextMsg, iSayText2;


/**
 * Возвращает конец мультибайтовой строки
 * 
 * @param buffer		Буфер для проверки
 * @param len			Длина строки
 * 
 * @return				Первый недействительный байт
 */
stock int EndMultibyteStr(const char[] buffer, int len)
{
    int bytes = 0, previous;
    while (bytes <= len)
    {
        if (!buffer[bytes] || bytes == len)
            return bytes;
        
        previous = GetCharBytes(buffer[bytes]);
        bytes += previous;
    }
    return bytes - previous;
}


public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    iTextMsg = GetUserMessageId("TextMsg");
    iSayText2 = GetUserMessageId("SayText2");

    MarkNativeAsOptional("Protobuf.SetInt");
    MarkNativeAsOptional("Protobuf.SetBool");
    MarkNativeAsOptional("Protobuf.SetString");
    MarkNativeAsOptional("Protobuf.AddString");

    MarkNativeAsOptional("BfWrite.WriteByte");
    MarkNativeAsOptional("BfWrite.WriteString");

    CreateNative("ChatModern.TextMsg", Native_TextMsg);
    CreateNative("ChatModern.CTextMsg", Native_CTextMsg);
    CreateNative("ChatModern.SayText2", Native_SayText2);
    CreateNative("ChatModern.CSayText2", Native_CSayText2);
    CreateNative("ChatModern.CPrintToChat", Native_CPrintToChat);

    RegPluginLibrary("chatmodern");
    
    return APLRes_Success;
}

int Native_TextMsg(Handle plugin, int numParams)
{
    int client = GetNativeCell(2);
    if (IsFakeClient(client))
        return;
    
    char buffer[CHAT_MODERN_NEW_SIZE];
    FormatNativeString(0, 3, 4, sizeof(buffer), _, buffer);

    TextMsg(GetNativeCell(1), client, buffer);
}

int Native_CTextMsg(Handle plugin, int numParams)
{
    int client = GetNativeCell(2);
    if (IsFakeClient(client))
        return;
    
    EngineVersion engine = GetNativeCell(1);

    char buffer[CHAT_MODERN_NEW_SIZE + CHAT_MODERN_NEW_SIZE_COLOR];
    FormatNativeString(0, 3, 4, sizeof(buffer), _, buffer);

    switch (engine)
    {
        case Engine_SourceSDK2006:
            ChatModern.Replace(sz(buffer), sz(ChatModern_sTagsEP1), ChatModern_iCodesEP1);

        case CHAT_MODERN_HEX_SUPPORT_CASE:
        {
            ChatModern.ReplaceHEX(sz(buffer), sz(ChatModern_sTagsHEX), ChatModern_sCodesHEX);
            ChatModern.ReplacePersonalHEX(sz(buffer));
        }

        default:
            ChatModern.Replace(sz(buffer), sz(ChatModern_sTags), ChatModern_iCodes);
    }

    TextMsg(engine, client, buffer);
}

int Native_SayText2(Handle plugin, int numParams)
{
    int client = GetNativeCell(2);
    if (IsFakeClient(client))
        return;
    
    char buffer[CHAT_MODERN_NEW_SIZE];
    FormatNativeString(0, 4, 5, sizeof(buffer), _, buffer);

    SayText2(GetNativeCell(1), client, GetNativeCell(3), buffer);
}

int Native_CSayText2(Handle plugin, int numParams)
{
    int client = GetNativeCell(2);
    if (IsFakeClient(client))
        return;

    char buffer[CHAT_MODERN_NEW_SIZE + CHAT_MODERN_NEW_SIZE_COLOR];
    FormatNativeString(0, 3, 4, sizeof(buffer), _, buffer);

    CSayText2(GetNativeCell(1), client, buffer);
}

int Native_CPrintToChat(Handle plugin, int numParams)
{
    int client = GetNativeCell(2);
    if (IsFakeClient(client))
        return;
    
    EngineVersion engine = GetNativeCell(1);

    char buffer[CHAT_MODERN_NEW_SIZE + CHAT_MODERN_NEW_SIZE_COLOR];
    FormatNativeString(0, 3, 4, sizeof(buffer), _, buffer);

    if (engine == Engine_SourceSDK2006)
    {
        ChatModern.Replace(sz(buffer), sz(ChatModern_sTagsEP1), ChatModern_iCodesEP1);

        if (FindTagsTeam(sz(buffer), sz(ChatModern_sTagsTeamEP1)) == -1)
        {
            TextMsg(engine, client, buffer);
        }
        else if (StrContains(buffer, view_as<char>({3})) == -1)
        {
            CSayText2(engine, client, buffer);
        }
        else
        {
            int pos, endpos, color, team, chr;
            for (;;)
            {
                color = StrContains(buffer[pos], view_as<char>({3}));
                team = FindTagsTeam(buffer[pos], sizeof(buffer) - pos, sz(ChatModern_sTagsTeamEP1));
                
                if (color == -1)
                {
                    CSayText2(engine, client, buffer[pos]);
                    return;
                }
                else if (team == -1)
                {
                    TextMsg(engine, client, buffer[pos]);
                    return;
                }
                else if (color < team)
                {
                    endpos += team;
                    chr = buffer[endpos];
                    buffer[endpos] = '\0';
                    TextMsg(engine, client, buffer[pos]);
                    buffer[endpos] = chr;
                }
                else if (team < color)
                {
                    endpos += color;
                    chr = buffer[endpos];
                    buffer[endpos] = '\0';
                    CSayText2(engine, client, buffer[pos]);
                    buffer[endpos] = chr;
                }

                pos = endpos;
            }
        }
    }
    else
    {
        if (CHAT_MODERN_HEX_SUPPORT(engine))
        {
            ChatModern.ReplaceHEX(sz(buffer), sz(ChatModern_sTagsHEX), ChatModern_sCodesHEX);
            ChatModern.ReplacePersonalHEX(sz(buffer));
        }
        else
        {
            ChatModern.Replace(sz(buffer), sz(ChatModern_sTags), ChatModern_iCodes);
        }

        if (FindTagsTeam(sz(buffer), sz(ChatModern_sTagsTeam)) == -1)
        {
            TextMsg(engine, client, buffer);
        }
        else if (StrContains(buffer, view_as<char>({3})) == -1)
        {
            CSayText2(engine, client, buffer);
        }
        else
        {
            int pos, endpos, color, team, chr;
            for (;;)
            {
                color = StrContains(buffer[pos], view_as<char>({3}));
                team = FindTagsTeam(buffer[pos], sizeof(buffer) - pos, sz(ChatModern_sTagsTeam));

                if (color == -1)
                {
                    CSayText2(engine, client, buffer[pos]);
                    return;
                }
                else if (team == -1)
                {
                    TextMsg(engine, client, buffer[pos]);
                    return;
                }
                else if (color < team)
                {
                    endpos += team;
                    chr = buffer[endpos];
                    buffer[endpos] = '\0';
                    TextMsg(engine, client, buffer[pos]);
                    buffer[endpos] = chr;
                }
                else if (team < color)
                {
                    endpos += color;
                    chr = buffer[endpos];
                    buffer[endpos] = '\0';
                    CSayText2(engine, client, buffer[pos]);
                    buffer[endpos] = chr;
                }
                pos = endpos;
            }
        }
    }
}

void TextMsg(EngineVersion engine, int client, char[] buffer)
{
    char color[CHAT_MODERN_SIZE_COLOR + 1], colorBuffer[CHAT_MODERN_SIZE + CHAT_MODERN_SIZE_COLOR];
    color = engine == Engine_CSGO ? " \x01" : "\x01";
    int clients[1], pos, endpos, currpos, chr, res, i;
    clients[0] = client;
    for (;;)
    {
        if (!(endpos = EndMultibyteStr(buffer[pos], CHAT_MODERN_SIZE - 2)))
            return;

        if ((res = FindCharInString(buffer[pos], '\n', true)) != -1)
            endpos = res + 1;

        endpos += pos;
        if (CHAT_MODERN_HEX_SUPPORT(engine))
        {
            if (7 < endpos && (
                    buffer[endpos - 1] == 7 || buffer[endpos - 2] == 7 || buffer[endpos - 3] == 7 || buffer[endpos - 4] == 7 ||
                    buffer[endpos - 5] == 7 || buffer[endpos - 6] == 7 || buffer[endpos - 7] == 7
                ))
            {
                endpos = endpos - 7;
            }
            else if (9 < endpos && (
                    buffer[endpos - 1] == 8 || buffer[endpos - 2] == 8 || buffer[endpos - 3] == 8 || buffer[endpos - 4] == 8 ||
                    buffer[endpos - 5] == 8 || buffer[endpos - 6] == 8 || buffer[endpos - 7] == 8 || buffer[endpos - 8] == 8 ||
                    buffer[endpos - 9] == 8
                ))
            {
                endpos = endpos - 9;
            }
        }

        chr = buffer[endpos];
        buffer[endpos] = '\0';
        i = strcopy(sz(colorBuffer), color);
        strcopy(colorBuffer[i], sizeof(colorBuffer) - i, buffer[pos]);

        Handle msg = StartMessageEx(iTextMsg, clients, 1);
        if (CHAT_MODERN_PROTOBUF_SUPPORT(engine))
        {
#define pb view_as<Protobuf>(msg)
            pb.SetInt("msg_dst", CHAT_MODERN_HUD_PRINTTALK);
            pb.AddString("params", colorBuffer);
            pb.AddString("params", "");
            pb.AddString("params", "");
            pb.AddString("params", "");
            pb.AddString("params", "");
#undef pb
        }
        else
        {
#define bf view_as<BfWrite>(msg)
            bf.WriteByte(CHAT_MODERN_HUD_PRINTTALK);
            bf.WriteString(colorBuffer);
#undef bf
        }
        EndMessage();

        if (chr)
        {
            i = currpos = -1;

            switch (engine)
            {
                case Engine_SourceSDK2006:
                {
                    while (++i < sizeof(ChatModern_iCodesEP1))
                        if (currpos < (res = FindCharInString(buffer[pos], ChatModern_iCodesEP1[i], true)))
                            currpos = res;

                    if (currpos != -1)
                        color[0] = buffer[pos + currpos];
                }
                case CHAT_MODERN_HEX_SUPPORT_CASE:
                {
                    while (++i < sizeof(ChatModern_iCodesHEX1))
                        if (currpos < (res = FindCharInString(buffer[pos], ChatModern_iCodesHEX1[i], true)))
                            currpos = res;

                    if (currpos != -1)
                    {
                        currpos += pos;
                        switch (buffer[currpos])
                        {
                            case 7:
                                strcopy(sz(color) - 2, buffer[currpos]);

                            case 8:
                                strcopy(sz(color), buffer[currpos]);

                            default:
                            {
                                color[0] = buffer[currpos];
                                color[1] = '\0';
                            }
                        }
                    }
                }
                default:
                {
                    while (++i < sizeof(ChatModern_iCodes))
                        if (currpos < (res = FindCharInString(buffer[pos], ChatModern_iCodes[i], true)))
                            currpos = res;

                    if (currpos != -1)
                    {
                        if (engine == Engine_CSGO)
                        {
                            color[0] = ' ';
                            color[1] = buffer[pos + currpos];
                        }
                        else
                        {
                            color[0] = buffer[pos + currpos];
                        }
                    }
                }
            }
            buffer[endpos] = chr;
            pos = endpos;
        }
        else
        {
            return;
        }
    }
}

void SayText2(EngineVersion engine, int client, int entity, char[] buffer)
{
    char color[CHAT_MODERN_SIZE_COLOR + 1], colorBuffer[CHAT_MODERN_SIZE + CHAT_MODERN_SIZE_COLOR];
    color = engine == Engine_CSGO ? " \x01" : "\x01";
    int clients[1], pos, endpos, currpos, chr, res, i;
    clients[0] = client;
    for (;;)
    {
        if (!(endpos = EndMultibyteStr(buffer[pos], CHAT_MODERN_SIZE - 2)))
            return;

        if ((res = FindCharInString(buffer[pos], '\n', true)) != -1)
            endpos = res + 1;

        endpos += pos;
        if (CHAT_MODERN_HEX_SUPPORT(engine))
        {
            if (7 < endpos && (
                    buffer[endpos - 1] == 7 || buffer[endpos - 2] == 7 || buffer[endpos - 3] == 7 || buffer[endpos - 4] == 7 ||
                    buffer[endpos - 5] == 7 || buffer[endpos - 6] == 7 || buffer[endpos - 7] == 7
                ))
            {
                endpos = endpos - 7;
            }
            else if (9 < endpos && (
                    buffer[endpos - 1] == 8 || buffer[endpos - 2] == 8 || buffer[endpos - 3] == 8 || buffer[endpos - 4] == 8 ||
                    buffer[endpos - 5] == 8 || buffer[endpos - 6] == 8 || buffer[endpos - 7] == 8 || buffer[endpos - 8] == 8 ||
                    buffer[endpos - 9] == 8
                ))
            {
                endpos = endpos - 9;
            }
        }

        chr = buffer[endpos];
        buffer[endpos] = '\0';
        i = strcopy(sz(colorBuffer), color);
        strcopy(colorBuffer[i], sizeof(colorBuffer) - i, buffer[pos]);

        Handle msg = StartMessageEx(iSayText2, clients, 1);
        if (CHAT_MODERN_PROTOBUF_SUPPORT(engine))
        {
#define pb view_as<Protobuf>(msg)
            pb.SetInt("ent_idx", entity);
            pb.SetBool("chat", true);
            pb.SetString("msg_name", colorBuffer);
            pb.AddString("params", "");
            pb.AddString("params", "");
            pb.AddString("params", "");
            pb.AddString("params", "");
#undef pb
        }
        else
        {
#define bf view_as<BfWrite>(msg)
            bf.WriteByte(entity);
            bf.WriteByte(1);
            bf.WriteString(colorBuffer);
#undef bf
        }
        EndMessage();

        if (chr)
        {
            i = currpos = -1;

            switch (engine)
            {
                case Engine_SourceSDK2006:
                {
                    while (++i < sizeof(ChatModern_iCodesEP1))
                        if (currpos < (res = FindCharInString(buffer[pos], ChatModern_iCodesEP1[i], true)))
                            currpos = res;

                    if (currpos != -1)
                        color[0] = buffer[pos + currpos];
                }
                case CHAT_MODERN_HEX_SUPPORT_CASE:
                {
                    while (++i < sizeof(ChatModern_iCodesHEX1))
                        if (currpos < (res = FindCharInString(buffer[pos], ChatModern_iCodesHEX1[i], true)))
                            currpos = res;

                    if (currpos != -1)
                    {
                        currpos += pos;
                        switch (buffer[currpos])
                        {
                            case 7:
                                strcopy(sz(color) - 2, buffer[currpos]);

                            case 8:
                                strcopy(sz(color), buffer[currpos]);

                            default:
                            {
                                color[0] = buffer[currpos];
                                color[1] = '\0';
                            }
                        }
                    }
                }
                default:
                {
                    while (++i < sizeof(ChatModern_iCodes))
                        if (currpos < (res = FindCharInString(buffer[pos], ChatModern_iCodes[i], true)))
                            currpos = res;

                    if (currpos != -1)
                    {
                        if (engine == Engine_CSGO)
                        {
                            color[0] = ' ';
                            color[1] = buffer[pos + currpos];
                        }
                        else
                        {
                            color[0] = buffer[pos + currpos];
                        }
                    }
                }
            }
            buffer[endpos] = chr;
            pos = endpos;
        }
        else
        {
            return;
        }
    }
}

void CSayText2(EngineVersion engine, int client, char[] buffer)
{
    int pos, endpos, res, index, chr;
    if (engine == Engine_SourceSDK2006)
    {
        for (;;)
        {
            res = ChatModern.ReplaceTeam(buffer[pos], CHAT_MODERN_NEW_SIZE + CHAT_MODERN_NEW_SIZE_COLOR - pos, sz(ChatModern_sTagsTeamEP1),
                index);
            if (res != -1)
            {
                endpos += res;
                chr = buffer[endpos];
                buffer[endpos] = '\0';
            }

            if (index < 1 || !(index = GetEntityByTeam(ChatModern_iTeamEP1[index], client)))
                index = client;

            SayText2(engine, client, index, buffer[pos]);

            if (res != -1)
            {
                buffer[endpos] = chr;
                pos = endpos;
            }
            else
            {
                return;
            }
        }
    }
    else
    {
        for (;;)
        {
            res = ChatModern.ReplaceTeam(buffer[pos], CHAT_MODERN_NEW_SIZE + CHAT_MODERN_NEW_SIZE_COLOR - pos, sz(ChatModern_sTagsTeam),
                index);
            if (res != -1)
            {
                endpos += res;
                chr = buffer[endpos];
                buffer[endpos] = '\0';
            }

            if (index < 1 || !(index = GetEntityByTeam(ChatModern_iTeam[index], client)))
                index = client;

            SayText2(engine, client, index, buffer[pos]);

            if (res != -1)
            {
                buffer[endpos] = chr;
                pos = endpos;
            }
            else
            {
                return;
            }
        }
    }
}

int FindTagsTeam(const char[] buffer, int maxlen, const char[][] tags, int maxtags)
{
    int i = -1, pos = maxlen, res;
    while (++i < maxtags)
        if ((res = StrContains(buffer, tags[i], CHAT_MODERN_TAGS_CSENSITIVE)) != -1 && res < pos)
            pos = res;
    return pos == maxlen ? -1 : pos;
}

int GetEntityByTeam(int team, int exception = 0)
{
    if (!bUSED_NOT_NULL())
        RequestFrame(RF_UsedNull);
    
    int i;
    while (++i <= MaxClients)
    {
        if (iTeam[i] == team)
        {
            bTRUE_EX(bBool, i);
            return i;
        }
    }
    
    i = 0;
    while (++i <= MaxClients)
    {
        if (i != exception && !bGET_EX(bBool, i) && IsClientInGame(i))
        {
            bTRUE_EX(bBool, i);
            SetEntProp(iResource, Prop_Send, "m_iTeam", team, 1, i);
            RequestFrame(RF_RestoreTeam, i << 4 | iTeam[i] << 2 | team);
            iTeam[i] = team;
            return i;
        }
    }
    return 0;
}

void RF_UsedNull()
{
    bUSED_NULL();
}

void RF_RestoreTeam(int data)
{
    int client = data >> 4;
    if (iTeam[client] == data & 3)
        iTeam[client] = (data >> 2) & 3;
}