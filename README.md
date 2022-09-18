# ChatModern
### Расширенные возможности чата для SourceMod 1.10+<br><br>

Позволяет использовать теги цветов и безопасно выводить большие тексты в чате<br><br>
Советую открыть **`chatmodern.inc`** и ознакомиться с описаниями методов

<br><br>
## Поддерживаемые теги
**`CS:S OLD (v34)`**:
```d
{default}       - обычный
{gold}          - золотой
{lightgreen}    - светло-зелёный
{green}         - зелёный
```
**`CS:S OB, TF2, HL2DM и DODS`**:
```d
{default}       - обычный
{white}         - белый
{darkred}       - тёмно-красный
{lightgreen}    - светло-зелёный
{green}         - зелёный
{lime}          - лаймовый
{purple}        - пурпурный
{red}           - красный
{grey}          - серый
{yellow}        - жёлтый
{gold}          - золотой
{blue}          - синий
{darkblue}      - тёмно-синий
{bluegrey}      - сине-серый
{pink}          - розовый
{lightred}      - светло-красный

{#FFFFFF}       - пользовательский; вместо FFFFFF можно подставлять свой цвет в формате HEX
```
**`Остальные игры`**:
```d
{default}       - обычный
{white}         - белый
{darkred}       - тёмно-красный
{purple}        - пурпурный
{green}         - зелёный
{lightgreen}    - светло-зелёный
{lime}          - лаймовый
{red}           - красный
{grey}          - серый
{yellow}        - жёлтый
{gold}          - золотой
{blue}          - синий
{darkblue}      - тёмно-синий
{bluegrey}      - сине-серый
{pink}          - розовый
{lightred}      - светло-красный
```

<br><br>
## Пример использования
**`main.sp`**:
```sp
// новый размер чата (в игре поддерживаются символы меньше 4 байт)
#define CHAT_MODERN_NEW_SIZE 512 * 3

// подключение ChatModern
#include <chatmodern>

public void OnPluginStart()
{
    // инициализация инклуда
    chatm.Init(GetEngineVersion());
    
    // вывод очень большого текста
    chatm.CPrintToChatAll("{green}переполнениебуферапереполнениебуфераперепо\nлнениебуферапереполнениебуферапереполнениебуфера\
        переполнениебуферапереполнениебуферапереполнениебуферапереполнениебуферапере{lightgreen}полнениебуферапереполнениебуфера\
        переполнениебуферапереполнениебуферапереполнениебуферапереполнениебуферапереполнениебуферапереполнениебуферапереполнениебуфера\
        переполнениебуферапереполнениебуферапереполнениебуферапереполнениебуферапереполнениебуферапереполнениебуферапереполнениебуфера\
        переполнениебуфера");
}
```
