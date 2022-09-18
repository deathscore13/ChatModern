/**
 * Расширенные возможности чата для SourceMod 1.10+
 * Протестировано на CS:S OLD (v34), CS:S OB (Steam) и CS:GO
 * 
 * https://github.com/deathscore13/ChatModern
 */

#if defined _chat_modern_included
 #endinput
#endif
#define _chat_modern_included

#if !defined CHAT_MODERN_NEW_SIZE
#warning CHAT_MODERN_NEW_SIZE was not defined, default value is used (512 * 3)
#define CHAT_MODERN_NEW_SIZE 512 * 3    /**< Новый размер чата (в игре поддерживаются символы меньше 4 байт) */
#endif
#define CHAT_MODERN_SIZE 192            /**< Безопасный размер чата в Engine_SourceSDK2006 */

/**
 * Проверяет поддерживает игра HEX или нет
 * 
 * @param %1        EngineVersion
 * 
 * @return          true если поддерживает, false если нет
 */
#define CHAT_MODERN_HEX_SUPPORT(%1) %1 == Engine_CSS || %1 == Engine_TF2 || %1 == Engine_HL2DM || %1 == Engine_DODS

// Цвета Engine_SourceSDK2006
stock char sChatModernTagsEP1[][] = {
    /* 00 */    "{default}",
    /* 01 */    "{gold}",
    /* 02 */    "{lightgreen}",
    /* 03 */    "{green}"
};
stock int iChatModernCodesEP1[] = {
    /* 00 */    0x01,
    /* 01 */    0x01,
    /* 02 */    0x03,
    /* 03 */    0x04
};

// Цвета для игр поддерживаемых HEX
stock char sChatModernTagsHEX[][] = {
    /* 00 */    "{default}",
    /* 01 */    "{white}",
    /* 02 */    "{darkred}",
    /* 03 */    "{lightgreen}",
    /* 04 */    "{green}",
    /* 05 */    "{lime}",
    /* 06 */    "{purple}",
    /* 07 */    "{red}",
    /* 08 */    "{grey}",
    /* 09 */    "{yellow}",
    /* 10 */    "{gold}",
    /* 11 */    "{blue}",
    /* 12 */    "{darkblue}",
    /* 13 */    "{bluegrey}",
    /* 14 */    "{pink}",
    /* 15 */    "{lightred}"
};
stock char sChatModernCodesHEX[][] = {
    /* 00 */    {0x01},
    /* 01 */    "\x07FFFFFF",
    /* 02 */    "\x07FF0000",
    /* 03 */    {0x03},
    /* 04 */    {0x04},
    /* 05 */    {0x05},
    /* 06 */    "\x07B880EF",
    /* 07 */    "\x07FF4040",
    /* 08 */    "\x07C9C9C9",
    /* 09 */    "\x07ECE479",
    /* 10 */    "\x07E0AD39",
    /* 11 */    "\x075C96D6",
    /* 12 */    "\x074C6AFF",
    /* 13 */    "\x07B0C2D8",
    /* 14 */    "\x07D22CE3",
    /* 15 */    "\x07EA4B4B"
};

stock int iChatModernCodesHEX1[] = {
    /* 00 */    0x01,
    /* 01 */    0x03,
    /* 02 */    0x04,
    /* 03 */    0x05,
    /* 04 */    0x07
};

// Цвета для остальных игр
stock char sChatModernTags[][] = {
    /* 00 */    "{default}",
    /* 01 */    "{white}",
    /* 02 */    "{darkred}",
    /* 03 */    "{purple}",
    /* 04 */    "{green}",
    /* 05 */    "{lightgreen}",
    /* 06 */    "{lime}",
    /* 07 */    "{red}",
    /* 08 */    "{grey}",
    /* 09 */    "{yellow}",
    /* 10 */    "{gold}",
    /* 11 */    "{blue}",
    /* 12 */    "{darkblue}",
    /* 13 */    "{bluegrey}",
    /* 14 */    "{pink}",
    /* 15 */    "{lightred}"
};
stock int iChatModernCodes[] = {
    /* 00 */    0x01,
    /* 01 */    0x01,
    /* 02 */    0x02,
    /* 03 */    0x03,
    /* 04 */    0x04,
    /* 05 */    0x05,
    /* 06 */    0x06,
    /* 07 */    0x07,
    /* 08 */    0x08,
    /* 09 */    0x09,
    /* 10 */    0x10,
    /* 11 */    0x0B,
    /* 12 */    0x0C,
    /* 13 */    0x0D,
    /* 14 */    0x0E,
    /* 15 */    0x0F
};


enum struct ChatModern
{
    EngineVersion iEngine;
    char color[8];

    /**
     * Инициализация. Должна выполняться самой первой ЕДИНОЖДЫ
     * 
     * @param engine        EngineVersion
     */
    void Init(EngineVersion engine)
    {
        this.iEngine = engine;
        if (engine == Engine_CSGO)
        {
            this.color[0] = ' ';
            this.color[1] = 0x01;
        }
        else
            this.color[0] = 0x01;
    }

    /**
     * Заменяет теги цветов в буфере в соответствии с кодами
     * 
     * @param buffer        Буфер
     * @param maxlen        Размер буфера
     * @param tags          Массив с тегами
     * @param maxtags       Размер массива с тегами
     * @param codes         Массив с кодами, соответствующий массиву с тегами
     */
    void Replace(char[] buffer, int maxlen, const char[][] tags, int maxtags, const int[] codes)
    {
        int i = -1;
        while (++i < maxtags)
            ReplaceString(buffer, maxlen, tags[i], view_as<char>(codes[i]), false);
    }

    /**
     * Заменяет персональные теги в буфере
     * 
     * @param buffer        Буфер
     */
    void ReplacePersonalHEX(char[] buffer)
    {
        int i = -1;
        while (buffer[++i])
        {
            if (buffer[i] == '{' && buffer[i + 1] == '#' && buffer[i + 8] == '}')
            {
                buffer[i] = 0x07;
                buffer[i + 1] = buffer[i + 2];
                buffer[i + 2] = buffer[i + 3];
                buffer[i + 3] = buffer[i + 4];
                buffer[i + 4] = buffer[i + 5];
                buffer[i + 5] = buffer[i + 6];
                buffer[i + 6] = buffer[i + 7];
                
                i += 6;
                while (buffer[i] && buffer[++i])
                    buffer[i] = buffer[i + 2];
                buffer[i + 1] = '\0';

                i = -1;
            }
        }
    }

    /**
     * Заменяет теги цветов в буфере в соответствии с HEX кодами
     * 
     * @param buffer        Буфер
     * @param maxlen        Размер буфера
     * @param tags          Массив с тегами
     * @param maxtags       Размер массива с тегами
     * @param codes         Массив с кодами, соответствующий массиву с тегами
     */
    void ReplaceHEX(char[] buffer, int maxlen, const char[][] tags, int maxtags, const char[][] codes)
    {
        int i = -1;
        while (++i < maxtags)
            ReplaceString(buffer, maxlen, tags[i], codes[i], false);
        
        this.ReplacePersonalHEX(buffer);
    }

    /**
     * Безопасный вывод текста в чат, не переполняющий буфер
     * 
     * @param client        Индекс клиента
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    void PrintToChat(int client, const char[] format, any ...)
    {
        char buffer[CHAT_MODERN_NEW_SIZE];
        VFormat(buffer, sizeof(buffer), format, 4);

        int pos, endpos, currpos, chr, res, i;
        for (;;)
        {
            if (!(endpos = EndMultibyteStr(buffer[pos], CHAT_MODERN_SIZE - 2)))
                return;
            
            if ((res = FindCharInString(buffer[pos], '\n', true)) != -1)
                endpos = res + 1;
            
            endpos += pos;
            if ((CHAT_MODERN_HEX_SUPPORT(this.iEngine)) && 7 < endpos &&
                (buffer[endpos - 1] == 0x07 || buffer[endpos - 2] == 0x07 || buffer[endpos - 3] == 0x07 || buffer[endpos - 4] == 0x07 ||
                buffer[endpos - 5] == 0x07 || buffer[endpos - 6] == 0x07 || buffer[endpos - 7] == 0x07))
                endpos = endpos - 7;
            
            chr = buffer[endpos];
            buffer[endpos] = '\0';

            PrintToChat(client, "%s%s", this.color, buffer[pos]);

            if (chr)
            {
                i = currpos = -1;

                if (this.iEngine == Engine_SourceSDK2006)
                {
                    while (++i < sizeof(iChatModernCodesEP1))
                    {
                        if (currpos < (res = FindCharInString(buffer[pos], iChatModernCodesEP1[i], true)))
                            currpos = res;
                    }
                    if (currpos != -1)
                        this.color[0] = buffer[pos + currpos];
                }
                else if (CHAT_MODERN_HEX_SUPPORT(this.iEngine))
                {
                    while (++i < sizeof(iChatModernCodesHEX1))
                    {
                        if (currpos < (res = FindCharInString(buffer[pos], iChatModernCodesHEX1[i], true)))
                            currpos = res;
                    }

                    if (currpos != -1)
                    {
                        currpos += pos;
                        if (buffer[currpos] == 0x07)
                            strcopy(this.color, sizeof(ChatModern::color), buffer[currpos]);
                        else
                        {
                            this.color[0] = buffer[currpos];
                            this.color[1] = '\0';
                        }
                    }
                }
                else
                {
                    while (++i < sizeof(iChatModernCodes))
                    {
                        if (currpos < (res = FindCharInString(buffer[pos], iChatModernCodes[i], true)))
                            currpos = res;
                    }
                    if (currpos != -1)
                    {
                        this.color[0] = ' ';
                        this.color[1] = buffer[pos + currpos];
                    }
                }
                buffer[endpos] = chr;
                pos = endpos;
            }
            else
            {
                if (this.iEngine == Engine_CSGO)
                {
                    this.color[0] = ' ';
                    this.color[1] = 0x01;
                    this.color[2] = '\0';
                }
                else
                {
                    this.color[0] = 0x01;
                    this.color[1] = '\0';
                }
                return;
            }
        }
    }

    /**
     * Замена тегов с цветами и безопасный вывод текста в чат
     * 
     * @param client        Индекс клиента
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    void CPrintToChat(int client, const char[] format, any ...)
    {
        char buffer[CHAT_MODERN_NEW_SIZE];
        VFormat(buffer, sizeof(buffer), format, 4);

        if (this.iEngine == Engine_SourceSDK2006)
            this.Replace(buffer, sizeof(buffer), sChatModernTagsEP1, sizeof(sChatModernTagsEP1), iChatModernCodesEP1);
        else if (CHAT_MODERN_HEX_SUPPORT(this.iEngine))
            this.ReplaceHEX(buffer, sizeof(buffer), sChatModernTagsHEX, sizeof(sChatModernTagsHEX), sChatModernCodesHEX);
        else
            this.Replace(buffer, sizeof(buffer), sChatModernTags, sizeof(sChatModernTags), iChatModernCodes);
        
        this.PrintToChat(client, "%s", buffer);
    }

    /**
     * Безопасный вывод текста в чат для всех игроков, не переполняющий буфер
     * 
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    void PrintToChatAll(const char[] format, any ...)
    {
        int i;
        char buffer[CHAT_MODERN_NEW_SIZE];
        while (++i <= MaxClients)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
            {
                SetGlobalTransTarget(i);
                VFormat(buffer, sizeof(buffer), format, 3);
                this.PrintToChat(i, "%s", buffer);
            }
        }
    }

    /**
     * Замена тегов с цветами и безопасный вывод текста в чат для всех игроков 
     * 
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    void CPrintToChatAll(const char[] format, any ...)
    {
        int i;
        char buffer[CHAT_MODERN_NEW_SIZE];
        while (++i <= MaxClients)
        {
            if (IsClientInGame(i))
            {
                SetGlobalTransTarget(i);
                VFormat(buffer, sizeof(buffer), format, 3);
                this.CPrintToChat(i, "%s", buffer);
            }
        }
    }
}

stock ChatModern chatm;
