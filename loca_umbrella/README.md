# Loca - Localization game

*Loca* is a game where you need to find all markers set by host player by walking around

You can find app deployed [here](http://blooming-dusk-12946.herokuapp.com/)

You can also run it locally.

Try

`mix deps.get`

`mix phx.server` 

In loca-umbrella directory

## HOW TO PLAY

You need at least 2 people - host and player. Game supports multiple players with one host.

Host picks 1 to n markers then presses "Start game". A poput with game link will appear. Copy this link and send it to players. Player need to input their name and press _join game_ button.
Player is then redirected to color-based page.

1. Green means player is on right track to next marker
2. Red means player is not on right track to next marker
3. Grey means player is not moving
4. Yellow means player managed to walk to marker
5. Pink means player has achieved final marker and won

All markers are shared between players, but only _current_ marker can be achieved by any player. First player to get to last one wins.

## Code itself
You can read more about code in specific projects README's

_Loca_ has all the backend code

_LocaWeb_ has all the frontend code
