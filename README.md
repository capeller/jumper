# Jumper Platforms Game

## Overview

Jumper Platforms Game is a vertical platformer built with Godot Engine 4, where the player must continuously jump across descending platforms to survive.

The project focuses on simple, fair, and deterministic gameplay, serving as a clean foundation for future expansion and backend integration.

## Current State

This repository currently contains the core gameplay layer only.

The main goal of this phase is to validate mechanics, platform generation rules, and player movement, while keeping the architecture intentionally simple and extensible.

## Gameplay Features

- Horizontal player movement
- Physics-based jumping
- Dynamically spawned platforms that:
  - Continuously move downward
  - Are generated across three invisible vertical lanes
  - Alternate lanes to avoid unreachable or unfair scenarios
- Automatic cleanup of off-screen platforms
- Initial collectible system (e.g. coins placed above platforms)

## Technology Stack

- Godot Engine 4 – Game engine
- GDScript – Gameplay scripting
- Git / GitHub – Version control and collaboration

## Architecture Overview

The project is designed with a clear separation of concerns, allowing gameplay to evolve independently from backend and persistence layers.

```
┌─────────────────────┐
│      Godot Game     │
│  (Client / Gameplay)│
└─────────┬───────────┘
          │
          │ (planned integration)
          ▼
┌─────────────────────┐
│   Go Backend API    │
│  (Game Services)   │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│    TigerBeetle DB   │
│ (High-performance  │
│  consistent store) │
└─────────────────────┘
```

## Gameplay Layer (Current Scope)

### Responsibilities

- Player input and movement
- Physics and collision handling
- Platform spawning and lifecycle
- Gameplay rules and constraints
- Visual representation

### Design Principles

- Deterministic platform generation
- Predictable difficulty progression
- Minimal scene coupling
- Stateless gameplay loop (no persistence yet)

## Platform Generation Rules

- Platforms spawn in three fixed horizontal lanes
- Consecutive platforms must not reuse the same lane
- This guarantees reachability and prevents unwinnable states
- Platforms are automatically removed once they leave the visible viewport

## Backend & Persistence (In Progress)

The following components are planned and currently under construction:

### Go Backend

- Game event handling
- Score submission
- Session tracking
- Future leaderboard support

### TigerBeetle Database

- High-performance, strongly consistent data storage
- Intended for:
  - Scores
  - Player progress
  - Game statistics

The backend will be integrated later, keeping the gameplay layer fully decoupled.

## Repository Structure

```
/scenes        → Godot scenes (Player, Platforms, Main)
/scripts       → Gameplay and spawning logic
/assets        → Textures and visual resources
```

## Contributing

Contributions are welcome, with the following guidelines:

- Use feature branches
- Open Pull Requests against main
- Keep commits small and descriptive
- Avoid introducing premature complexity
- Discuss architectural changes before implementing them

## Branch Protection

- The main branch is protected
- All changes must go through Pull Requests
- Direct pushes to main are not allowed

## Roadmap

- Gameplay polish and tuning
- Difficulty balancing
- Backend integration (Go)
- Persistent data storage (TigerBeetle)

## Status

🚧 Active development

This project represents the foundation of a larger system and is expected to evolve.

## License

To be defined.
