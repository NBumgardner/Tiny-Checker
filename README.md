# Tiny Checkers - Fork

Fork of the Tiny Checkers game, originally invented by thyoi for the Ludum Dare 56 game jam.

## Original Game Links

See the original [web game](https://thiori.itch.io/tinycheckers), [rated entry](https://ldjam.com/events/ludum-dare/56/tiny-checkers), and [code](https://github.com/thyoi/Tiny-Checker).

## Gameplay

The goal is to win the last battle on the overview map.

The gameplay starts with an introduction, first battle, overview map, and then a shop. Overall the gameplay alternates between battling a computer opponent and visiting a shop that sells new checker pieces to help the player gain power.

### Battle Phase

During battles, the top-center number represents how many points worth of pieces the player has left on the board.

Destroying pieces earns gold to spend at shops for new pieces.

All of your pieces come back after every won battle.

### Shop Phase

During shops, choose up to 3 pieces to buy, adding them into your backpack to customize which pieces you bring into the next battle.

### Overview Map

Between battles and shops, the camera pans to the right to focus on the next clickable activity. This is also the time when you may open your backback to setup which pieces in which formation will be used in the next battle.

## Differences from Original

As of May 2025, the only change was to upgrade to the latest Godot engine version 4.4.

### Enhancements Made

Enhancements made on this fork:

- Upgraded the engine from Godot 4.3 to 4.4.
- Fixed a Godot 4.4 introduced visual rounding bug for file `_UI/Score/Score.gd` method `SetNum`. to return an integer instead of a floating point number for the top-center number representing how many points of pieces the player has left on the board.

### Enhancements Missing

Missing enhancements are the post-game jam bug fixes not on the original GitHub repository, and may include:

- Slightly different tutorial text and visuals.
- Missing hint at number of levels left.

See the [original inventor's Ludum Dare entry page](https://ldjam.com/events/ludum-dare/56/tiny-checkers) and its linked itch.io page for more patch notes information.
