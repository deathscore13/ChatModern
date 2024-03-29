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

{team}          - текущая команда
{team1}         - спектаторы
{team2}         - террористы
{team3}         - спецназ
{grey}          - спектаторы
{red}           - террористы
{blue}          - спецназ

{old}           - предыдущий тег
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
{blue}          - синий
{darkblue}      - тёмно-синий
{bluegrey}      - сине-серый
{pink}          - розовый
{lightred}      - светло-красный
{gold}          - золотой

{#FFFFFF}       - пользовательский (без регулировки прозрачности); вместо FFFFFF можно подставлять свой цвет в формате HEX
{#FFFFFFFF}     - пользовательский (с регулировкой прозрачности); вместо FFFFFFFF можно подставлять свой цвет в формате HEX

{team}          - текущая команда
{team1}         - команда 1
{team2}         - команда 2
{team3}         - команда 3

{old}           - предыдущий тег
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
{blue}          - синий
{darkblue}      - тёмно-синий
{bluegrey}      - сине-серый
{pink}          - розовый
{lightred}      - светло-красный
{gold}          - золотой

{team}          - текущая команда
{team1}         - команда 1
{team2}         - команда 2
{team3}         - команда 3

{old}           - предыдущий тег
```
<br><br>
## Требования
1. SourceMod 1.10+;
2. [macros.inc](https://github.com/deathscore13/macros.inc) для сборки проекта.

<br><br>
## Установка
1. Собрать **`chatmodern.sp`** с помощью **`spcomp`**;
2. Переместить **`chatmodern.smx`** в **`addons/sourcemod/plugins`**;
3. Перезапустить сервер, сменить карту или выполнить `sm plugins load chatmodern`. 

<br>Настройки находятся в **`cfg/chatmodern.cfg`**.

<br><br>
## Пример использования
**`main.sp`**:
```sp
#include <sourcemod>

// подключение ChatModern
#include <chatmodern>

// объявление переменной
ChatModern chatm;

public void OnPluginStart()
{
    // создание объекта ChatModern
    chatm = new ChatModern(GetEngineVersion());

    RegConsoleCmd("sm_example", ConsoleCmd_example);
}

Action ConsoleCmd_example(int client, int args)
{
    // вывод очень большого текста
    chatm.CPrintToChat(client, "{default}переполнение буфера {gold}переполнение буфера \
        {lightgreen}переполнение буфера {green}переполнение буфера {grey}переполнение буфера \
        {red}переполнение буфера {blue}переполнение буфера {team}переполнение буфера \
        {team1}переполнение буфера {team2}переполнение буфера {team3}переполнение буфера");
}
```
