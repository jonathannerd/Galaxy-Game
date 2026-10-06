<div align="center">
  <img src="Galaxy_Game/data/space%20(2).png" alt="Galaxy Game spaceship artwork" width="760">

  # Galaxy Game

  **A full-screen Processing space shooter with upgrades, escalating meteors, and three boss battles.**
</div>

## About

Pilot a ship through a scrolling space arena, destroy incoming meteors, survive with limited health, and fight bosses as your score climbs. Points earned across runs can unlock stronger ships and additional hearts in the shop.

## Features

- Smooth movement with WASD or arrow keys
- Projectile combat and explosion animation
- Meteors that gain speed and health as the score rises
- Boss encounters at score milestones
- Three bosses with increasing health and projectiles
- Persistent session currency for a ship-and-health shop
- Multiple ships with improved damage
- Menu, options, shop, death, and victory states
- Bundled artwork, music, and sound effects

## Controls

| Key | Action |
| --- | --- |
| <kbd>W</kbd><kbd>A</kbd><kbd>S</kbd><kbd>D</kbd> | Move |
| Arrow keys | Alternative movement |
| <kbd>Space</kbd> | Fire |
| Mouse | Navigate menus, options, and shop |

## Progression

Regular meteors award points and become tougher over time. Bosses appear at score milestones of 50, 100, and 150. Defeating the final boss completes the run, while accumulated points can be spent on stronger ships and extra health.

## Run the game

1. Install [Processing 4](https://processing.org/download).
2. Install the **Sound** library through Processing's Contribution Manager.
3. Clone the repository.
4. Open `Galaxy_Game/Galaxy_Game.pde`.
5. Press **Run**.

The sketch expects every image and audio file to remain in `Galaxy_Game/data/`.

## Built with

- Processing
- Processing Sound
- Array lists for meteors, shots, explosions, and boss projectiles
- Collision detection and difficulty scaling
- Menu and game-state management
