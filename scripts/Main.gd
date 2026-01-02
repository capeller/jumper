extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var game_over: Control = $HUD/GameOver
@onready var platforms: Node2D = $Platforms
@onready var spawner: Node2D = $PlatformSpawner

func _ready() -> void:
	# Initial HUD state
	game_over.visible = false

	# =====================================================
	# INITIAL PLATFORM (SINGLE SOURCE: SPAWNER)
	# =====================================================
	var start_platform: Node2D = spawner.spawn_start_platform() as Node2D
	if start_platform == null:
		push_error("Failed to create the initial platform (spawn_start_platform returned null).")
		return

	position_player_on_platform(start_platform)

	# =====================================================
	# CONNECTIONS
	# =====================================================
	player.died.connect(_on_player_died)

	# =====================================================
	# START CONTINUOUS SPAWNING
	# =====================================================
	spawner.start_spawning()

# =========================================================
# PLAYER POSITIONING
# =========================================================

func position_player_on_platform(platform: Node2D) -> void:
	var collision: CollisionShape2D = player.get_node("CollisionShape2D")
	var shape: RectangleShape2D = collision.shape
	var player_height: float = shape.size.y * collision.scale.y

	# Extra offset to start higher
	var start_offset_y := 80.0

	player.global_position = Vector2(
		platform.global_position.x,
		platform.global_position.y - player_height / 2.0 - start_offset_y
	)

# =========================================================
# GAME OVER
# =========================================================

func _on_player_died() -> void:
	spawner.stop_spawning()
	$HUD.show_game_over()
	get_tree().paused = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	GameManager.reset()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
