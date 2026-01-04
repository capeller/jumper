extends Node2D

@onready var player: Player = $Player
@onready var game_over: Control = $HUD/GameOver
@onready var hud: CanvasLayer = $HUD
@onready var platforms: Node2D = $Platforms
@onready var spawner: Node2D = $PlatformSpawner

func _ready() -> void:
	game_over.visible = false

	var start_platform: Node2D = spawner.spawn_start_platform()
	if start_platform == null:
		push_error("Failed to create the initial platform.")
		return

	position_player_on_platform(start_platform)

	player.died.connect(_on_player_died)
	spawner.start_spawning()

func position_player_on_platform(platform: Node2D) -> void:
	var collision := player.get_node("CollisionShape2D") as CollisionShape2D
	var shape := collision.shape as RectangleShape2D
	var player_height := shape.size.y * collision.scale.y

	player.global_position = Vector2(
		platform.global_position.x,
		platform.global_position.y - player_height / 2.0 - 80.0
	)

# =========================================================
# GAME OVER
# =========================================================
func _on_player_died() -> void:
	spawner.stop_spawning()
	game_over.set_score(GameManager.score)

	hud.on_player_died()
	$HUD/Controls.visible = false
	game_over.visible = true

	get_tree().paused = true

func _on_restart_pressed() -> void:
	get_tree().paused = false
	GameManager.reset()
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
