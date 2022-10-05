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

// После изменения констант необходимо пересобрать chatmodern.smx
#define CHAT_MODERN_NEW_SIZE 512 * 3        /**< Новый размер чата (в игре поддерживаются символы меньше 4 байт) */
#define CHAT_MODERN_NEW_SIZE_COLOR 128      /**< Дополнительный размер для тегов */

#define CHAT_MODERN_SIZE 192                /**< Безопасный размер чата */
#define CHAT_MODERN_SIZE_COLOR 9            /**< Максимальный размер цвета */

#define CHAT_MODERN_TAGS_CSENSITIVE false   /**< Чувствительность тегов к регистру */

/**
 * Проверяет поддерживает игра HEX или нет
 * 
 * @param %1        EngineVersion
 * 
 * @return          true если поддерживает, false если нет
 */
#define CHAT_MODERN_HEX_SUPPORT(%1) (%1 == Engine_CSS || %1 == Engine_TF2 || %1 == Engine_HL2DM || %1 == Engine_DODS)

#define CHAT_MODERN_HEX_SUPPORT_CASE Engine_CSS, Engine_TF2, Engine_HL2DM, Engine_DODS  /**< Перечисление игр, поддерживаемых HEX */

/**
 * Проверяет поддерживает игра protobuf или нет
 * 
 * @param %1        EngineVersion
 * 
 * @return          true если поддерживает, false если нет
 */
#define CHAT_MODERN_PROTOBUF_SUPPORT(%1) (%1 == Engine_CSGO || %1 == Engine_Blade)

#define CHAT_MODERN_PROTOBUF_SUPPORT_CASE Engine_CSS, Engine_TF2, Engine_HL2DM, Engine_DODS  /**< Перечисление игр, поддерживаемых protobuf */

// Цвета Engine_SourceSDK2006
stock char ChatModern_sTagsEP1[][] = {
    /* 00 */    "{default}",
    /* 01 */    "{gold}",
    /* 02 */    "{lightgreen}",
    /* 03 */    "{green}"
};
stock int ChatModern_iCodesEP1[] = {
    /* 00 */    1,
    /* 01 */    1,
    /* 02 */    3,
    /* 03 */    4
};

stock char ChatModern_sTagsTeamEP1[][] = {
    /* 00 */    "{team}",
    /* 01 */    "{team1}",
    /* 02 */    "{team2}",
    /* 03 */    "{team3}",
    /* 04 */    "{grey}",
    /* 05 */    "{red}",
    /* 06 */    "{blue}",
};
stock int ChatModern_iTeamEP1[] = {
    /* 00 */    0,  // текущая команда
    /* 01 */    1,
    /* 02 */    2,
    /* 03 */    3,
    /* 04 */    1,
    /* 05 */    2,
    /* 06 */    3,
};

// Цвета для игр поддерживаемых HEX
stock char ChatModern_sTagsHEX[][] = {
    /* 00 */    "{default}",
    /* 01 */    "{green}",
    /* 02 */    "{lime}",
    /* 03 */    "{lightgreen}",
    /* 04 */    "{darkred}",
    /* 05 */    "{purple}",
    /* 06 */    "{red}",
    /* 07 */    "{grey}",
    /* 08 */    "{yellow}",
    /* 09 */    "{gold}",
    /* 10 */    "{blue}",
    /* 11 */    "{darkblue}",
    /* 12 */    "{bluegrey}",
    /* 13 */    "{pink}",
    /* 14 */    "{lightred}"
};
stock char ChatModern_sCodesHEX[][] = {
    /* 00 */    {1},
    /* 01 */    {4},
    /* 02 */    {5},
    /* 03 */    "\x07BFFE90",   // чтобы не использовать {3} и не разбивать текст на TextMsg/SayText2
    /* 04 */    "\x07FF0000",
    /* 05 */    "\x07B880EF",
    /* 06 */    "\x07FF4040",
    /* 07 */    "\x07C9C9C9",
    /* 08 */    "\x07ECE479",
    /* 09 */    "\x07E0AD40",
    /* 10 */    "\x075C96D6",
    /* 11 */    "\x074C6AFF",
    /* 12 */    "\x07B0C2D8",
    /* 13 */    "\x07D22CE3",
    /* 14 */    "\x07EA4B4B"
};

stock int ChatModern_iCodesHEX1[] = {
    /* 00 */    1,
    /* 01 */    3,
    /* 02 */    4,
    /* 03 */    5,
    /* 04 */    7,
    /* 05 */    8
};

#define CHAT_MODERN_HEX_PERSONAL_START '{'      /**< Начало персонального HEX тега */
#define CHAT_MODERN_HEX_PERSONAL_HEADER '#'     /**< Заголовок персонального HEX тега */
#define CHAT_MODERN_HEX_PERSONAL_END '}'        /**< Конец персонального HEX тега */

// Цвета для остальных игр
stock char ChatModern_sTags[][] = {
    /* 00 */    "{default}",
    /* 01 */    "{darkred}",
    /* 02 */    "{purple}",
    /* 03 */    "{green}",
    /* 04 */    "{lightgreen}",
    /* 05 */    "{lime}",
    /* 06 */    "{red}",
    /* 07 */    "{grey}",
    /* 08 */    "{yellow}",
    /* 09 */    "{gold}",
    /* 10 */    "{blue}",
    /* 11 */    "{darkblue}",
    /* 12 */    "{bluegrey}",
    /* 13 */    "{pink}",
    /* 14 */    "{lightred}"
};
stock int ChatModern_iCodes[] = {
    /* 00 */    1,
    /* 01 */    2,
    /* 02 */    3,
    /* 03 */    4,
    /* 04 */    5,
    /* 05 */    6,
    /* 06 */    7,
    /* 07 */    8,
    /* 08 */    9,
    /* 09 */    10,
    /* 10 */    12,
    /* 11 */    13,
    /* 12 */    14,
    /* 13 */    15,
    /* 14 */    16
};

// Для HEX и остальных
stock char ChatModern_sTagsTeam[][] = {
    /* 00 */    "{team}",
    /* 01 */    "{team1}",
    /* 02 */    "{team2}",
    /* 03 */    "{team3}"
};
stock int ChatModern_iTeam[] = {
    /* 00 */    0,  // текущая команда
    /* 01 */    1,
    /* 02 */    2,
    /* 03 */    3
};


methodmap ChatModern < Handle
{
    /**
     * Создание объекта ChatModern
     * Не требует закрытия через CloseHandle()
     * 
     * @param engine        EngineVersion
     * 
     * @return              Объект ChatModern
     */
    public ChatModern(EngineVersion engine)
    {
        // неожиданно, правда?
        return view_as<ChatModern>(engine);
    }

    /**
     * Вывод текста в чат, не переполняющий буфер
     * 
     * @param client        Индекс клиента
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public native void TextMsg(int client, const char[] format, any ...);

    /**
     * Замена тегов с цветами и вывод текста в чат, не переполняющий буфер
     * 
     * @param client        Индекс клиента
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public native void CTextMsg(int client, const char[] format, any ...);

    /**
     * Вывод текста в чат через SayText2, не переполняющий буфер
     * 
     * @param client        Индекс клиента
     * @param entity        Энтити отправителя
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public native void SayText2(int client, int entity, const char[] format, any ...);

    /**
     * Замена тегов с командами и вывод текста в чат через SayText2, не переполняющий буфер
     * 
     * @param client        Индекс клиента
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public native void CSayText2(int client, const char[] format, any ...);

    /**
     * Замена тегов с цветами и командами, и вывод текста в чат через TextMsg и SayText2, не переполняющий буфер
     * 
     * @param client        Индекс клиента
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public native void CPrintToChat(int client, const char[] format, any ...);

#if !defined SPCOMP_MOD || defined PUBVAR_MAXCLIENTS
    /**
     * Вывод текста в чат для всех игроков, не переполняющий буфер
     * 
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public void TextMsgAll(const char[] format, any ...)
    {
        int i;
        char buffer[CHAT_MODERN_NEW_SIZE];
        while (++i <= MaxClients)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
            {
                SetGlobalTransTarget(i);
                VFormat(buffer, sizeof(buffer), format, 3);
                this.TextMsg(i, "%s", buffer);
            }
        }
    }

    /**
     * Замена тегов с цветами и вывод текста в чат для всех игроков, не переполняющий буфер
     * 
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public void CTextMsgAll(const char[] format, any ...)
    {
        int i;
        char buffer[CHAT_MODERN_NEW_SIZE + CHAT_MODERN_NEW_SIZE_COLOR];
        while (++i <= MaxClients)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
            {
                SetGlobalTransTarget(i);
                VFormat(buffer, sizeof(buffer), format, 3);
                this.CTextMsg(i, "%s", buffer);
            }
        }
    }
    
    /**
     * Вывод текста в чат через SayText2 для всех игроков, не переполняющий буфер
     * 
     * @param entity        Энтити отправителя
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public void SayText2All(int entity, const char[] format, any ...)
    {
        int i;
        char buffer[CHAT_MODERN_NEW_SIZE];
        while (++i <= MaxClients)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
            {
                SetGlobalTransTarget(i);
                VFormat(buffer, sizeof(buffer), format, 3);
                this.SayText2(i, entity, "%s", buffer);
            }
        }
    }

    /**
     * Замена тегов с командами и вывод текста в чат через SayText2 для всех игроков, не переполняющий буфер
     * 
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public void CSayText2All(const char[] format, any ...)
    {
        int i;
        char buffer[CHAT_MODERN_NEW_SIZE + CHAT_MODERN_NEW_SIZE_COLOR];
        while (++i <= MaxClients)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
            {
                SetGlobalTransTarget(i);
                VFormat(buffer, sizeof(buffer), format, 3);
                this.CSayText2(i, "%s", buffer);
            }
        }
    }

    /**
     * Замена тегов с цветами и командами, и вывод текста в чат через TextMsg/SayText2 для всех игроков, не переполняющий буфер
     * 
     * @param format        Строка для форматирования
     * @param ...           Аргументы для форматирования
     */
    public void CPrintToChatAll(const char[] format, any ...)
    {
        int i;
        char buffer[CHAT_MODERN_NEW_SIZE + CHAT_MODERN_NEW_SIZE_COLOR];
        while (++i <= MaxClients)
        {
            if (IsClientInGame(i) && !IsFakeClient(i))
            {
                SetGlobalTransTarget(i);
                VFormat(buffer, sizeof(buffer), format, 3);
                this.CPrintToChat(i, "%s", buffer);
            }
        }
    }
#endif

    /**
     * Заменяет теги цветов в буфере в соответствии с кодами
     * 
     * @param buffer        Буфер
     * @param maxlen        Размер буфера
     * @param tags          Массив с тегами
     * @param maxtags       Размер массива с тегами
     * @param codes         Массив с кодами
     */
    public static void Replace(char[] buffer, int maxlen, const char[][] tags, int maxtags, const int[] codes)
    {
        int i = -1;
        while (++i < maxtags)
            ReplaceString(buffer, maxlen, tags[i], view_as<char>(codes[i]), CHAT_MODERN_TAGS_CSENSITIVE);
    }

    /**
     * Заменяет теги цветов в буфере в соответствии с HEX кодами
     * 
     * @param buffer        Буфер
     * @param maxlen        Размер буфера
     * @param tags          Массив с тегами
     * @param maxtags       Размер массива с тегами
     * @param codes         Массив с кодами
     */
    public static void ReplaceHEX(char[] buffer, int maxlen, const char[][] tags, int maxtags, const char[][] codes)
    {
        int i = -1;
        while (++i < maxtags)
            ReplaceString(buffer, maxlen, tags[i], codes[i], CHAT_MODERN_TAGS_CSENSITIVE);
    }

    /**
     * Заменяет персональные HEX теги в буфере
     * 
     * @param buffer        Буфер
     */
    public static void ReplacePersonalHEX(char[] buffer)
    {
        int i = -1;
        while (buffer[++i])
        {
            if (buffer[i] == CHAT_MODERN_HEX_PERSONAL_START && buffer[i + 1] == CHAT_MODERN_HEX_PERSONAL_HEADER &&
                buffer[i + 8] == CHAT_MODERN_HEX_PERSONAL_END)
            {
                buffer[i] = 7;
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
            else if (buffer[i] == CHAT_MODERN_HEX_PERSONAL_START && buffer[i + 1] == CHAT_MODERN_HEX_PERSONAL_HEADER &&
                buffer[i + 10] == CHAT_MODERN_HEX_PERSONAL_END)
            {
                buffer[i] = 8;
                buffer[i + 1] = buffer[i + 2];
                buffer[i + 2] = buffer[i + 3];
                buffer[i + 3] = buffer[i + 4];
                buffer[i + 4] = buffer[i + 5];
                buffer[i + 5] = buffer[i + 6];
                buffer[i + 6] = buffer[i + 7];
                buffer[i + 7] = buffer[i + 8];
                buffer[i + 8] = buffer[i + 9];

                i += 8;
                while (buffer[i] && buffer[++i])
                    buffer[i] = buffer[i + 2];
                buffer[i + 1] = '\0';

                i = -1;
            }
        }
    }

    /**
     * Заменяет теги цветов команд до следующего тега
     * Например до {team1} в "{team}бла бла {team}бла {team1}бла {team}бла"
     * 
     * @return              Позиция цвета другой команды
     */
    public static int ReplaceTeam(char[] buffer, int maxlen, const char[][] tags, int maxtags, int &index)
    {
        int i = -1, pos = maxlen, res;
        while (++i < maxtags)
        {
            if ((res = StrContains(buffer, tags[i], CHAT_MODERN_TAGS_CSENSITIVE)) != -1 && res < pos)
            {
                pos = res;
                index = i;
            }
        }

        if (pos == maxlen)
        {
            index = -1;
        }
        else
        {
            i = -1;
            pos = maxlen;
            while (++i < maxtags)
                if (i != index && (res = StrContains(buffer, tags[i], CHAT_MODERN_TAGS_CSENSITIVE)) != -1 && res < pos)
                    pos = res;
            
            if (pos == maxlen)
            {
                ReplaceString(buffer, maxlen, tags[index], view_as<char>({3}), true);
            }
            else
            {
                res = pos;
                i = buffer[pos];
                buffer[pos] = '\0';
                pos -= (strlen(tags[index]) - 1) * ReplaceString(buffer, pos, tags[index], view_as<char>({3}), CHAT_MODERN_TAGS_CSENSITIVE);
                buffer[res] = i;
                strcopy(buffer[pos], maxlen - pos, buffer[res]);
            }
        }
        return pos == maxlen ? -1 : pos;
    }
}