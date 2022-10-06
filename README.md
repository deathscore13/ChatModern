# ChatModern
### Расширенные возможности чата для SourceMod 1.10+<br><br>

Позволяет использовать теги цветов и безопасно выводить большие тексты в чате<br><br>
Советую открыть **`chatmodern.inc`** и ознакомиться с описаниями методов<br><br>

Протестировано на **CS:S OLD (v34)**, **CS:S OB (Steam)** и **CS:GO**.<br>
Пожалуйста, [создайте issue](https://github.com/deathscore13/ChatModern/issues/new) с результатами тестов, если у вас другая игра.

<br><br>
## Поддерживаемые теги
**`CS:S OLD (v34)`**:
```d
{default}       - обычный
{gold}          - золотой
{lightgreen}    - светло-зелёный
{green}         - зелёный

Команды:
{team}          - текущая
{team1}         - спектаторы
{team2}         - террористы
{team3}         - спецназ
{grey}          - спектаторы
{red}           - террористы
{blue}          - спецназ
```
**`CS:S OB, TF2, HL2DM и DODS`**:
```d
{default}       - обычный
{green}         - зелёный
{lime}          - лаймовый
{lightgreen}    - светло-зелёный
{darkred}       - тёмно-красный
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

{#FFFFFF}       - пользовательский (без регулировки прозрачности); вместо FFFFFF можно подставлять свой цвет в формате HEX
{#FFFFFFFF}     - пользовательский (с регулировкой прозрачности); вместо FFFFFFFF можно подставлять свой цвет в формате HEX

Команды:
{team}          - текущая
{team1}         - команда 1
{team2}         - команда 2
{team3}         - команда 3
```
**`Остальные игры`**:
```d
{default}       - обычный
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

Команды:
{team}          - текущая
{team1}         - команда 1
{team2}         - команда 2
{team3}         - команда 3
```
<br><br>
## Установка
Если `tv_enable` = 1:
1. Переместить **`chatmodern.smx`** в **`addons/sourcemod/plugins`**;
2. Перезапустить сервер.

Если `tv_enable` = 0:
1. Переместить **`chatmodern.smx`** в **`addons/sourcemod/plugins`**;
2. Перезапустить сервер, сменить карту или выполнить `sm plugins load chatmodern`. 

<br>Настройки находятся в **`cfg/chatmodern.cfg`**.

<br><br>
## Пример использования
**`main.sp`**:
```sp
// подключение ChatModern
#include <chatmodern>

// объявление переменной
ChatModern chatm;

public void OnPluginStart()
{
    // создание объекта ChatModern
    chatm = new ChatModern(GetEngineVersion());
    
    // вывод очень большого текста
    chatm.CPrintToChatAll("{default}переполнение буфера {gold}переполнение буфера \
        {lightgreen}переполнение буфера {green}переполнение буфера {grey}переполнение буфера \
        {red}переполнение буфера {blue}переполнение буфера {team}переполнение буфера \
        {team1}переполнение буфера {team2}переполнение буфера {team3}переполнение буфера");
}
```
