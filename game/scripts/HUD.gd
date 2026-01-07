extends CanvasLayer

# =========================================================
# HUD ELEMENTS
# =========================================================
@onready var coins_label: Label = $TopLeft/Coins
@onready var game_over_panel: Control = $GameOver
@onready var coins_result: Label = $GameOver/Panel/VBox/CoinsResult

@onready var player: Player = get_tree().get_first_node_in_group("player") as Player

# =========================================================
# INITIALIZATION
# =========================================================
func _ready() -> void:
	coins_label.text = "Coins: 0"
	game_over_panel.visible = false
	GameManager.coins_changed.connect(_on_coins_changed)

	if player == null:
		await get_tree().process_frame
		player = get_tree().get_first_node_in_group("player") as Player

# =========================================================
# HUD LIFECYCLE
# =========================================================
func on_player_died() -> void:
	player = null
	$Controls.visible = false

# =========================================================
# HUD LOGIC
# =========================================================
func _on_coins_changed(total: int) -> void:
	coins_label.text = "Coins: %d" % total

func show_game_over() -> void:
	coins_result.text = "Coins collected: %d" % GameManager.coins
	game_over_panel.visible = true
