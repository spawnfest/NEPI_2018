# Loca Web

To start your server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

You can also visit [`https://blooming-dusk-12946.herokuapp.com`](https://blooming-dusk-12946.herokuapp.com)

## Architecture


![Architecture](../../arch.png "Architecture")


## Basic components

GameChannel:
  Communication between game host, players and server - used to send messages with game status and player localization.

GameController:
  - start_game - starts GameManager
  - check_position - get info about player position to nearest point
  - make_user & join - creates user and joins to started game


## How it works

### Game start
![Start game](../../start_game.gif "Start game")

### Game
![Game](../../game.gif "Game")

### Player perspective
  Player interface is dead simple, it just show colors
  - when there is no movement:

  ![Gray](../../gray.png)

  - when player  moving in the right direction

  ![Green](../../green.png "Green")

  - when player is moving in the wrong direction

  ![Red](../../red.png "Red")

  - when player won

  ![Pink](../../pink.png "Pink")
