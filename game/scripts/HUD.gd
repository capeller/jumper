extends CanvasLayer

@onready var coins_label: Label = $TopLeft/Coins
@onready var game_over_panel: Control = $GameOver
@onready var coins_result: Label = $GameOver/Panel/VBox/CoinsResult

@onready var hold_timer: Timer = $Controls/HoldTimer
@onready var player: Player = get_tree().get_first_node_in_group("player") as Player

var holding_left := false
var holding_right := false

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
	holding_left = false
	holding_right = false
	hold_timer.stop()

# =========================================================
# HUD LOGIC
# =========================================================
func _on_coins_changed(total: int) -> void:
	coins_label.text = "Coins: %d" % total

func show_game_over() -> void:
	coins_result.text = "Coins collected: %d" % GameManager.coins
	game_over_panel.visible = true

# =========================================================
# LEFT BUTTON
# =========================================================
func _on_left_button_button_down() -> void:
	if player == null:
		return

	holding_left = true
	holding_right = false
	hold_timer.stop()

	player.touch_left = true
	await get_tree().process_frame
	if player != null:
		player.touch_left = false

	hold_timer.start()

func _on_left_button_button_up() -> void:
	if player == null:
		return

	holding_left = false
	player.touch_left = false
	hold_timer.stop()

# =========================================================
# RIGHT BUTTON
# =========================================================
func _on_right_button_button_down() -> void:
	if player == null:
		return

	holding_right = true
	holding_left = false
	hold_timer.stop()

	player.touch_right = true
	await get_tree().process_frame
	if player != null:
		player.touch_right = false

	hold_timer.start()

func _on_right_button_button_up() -> void:
	if player == null:
		return

	holding_right = false
	player.touch_right = false
	hold_timer.stop()

# =========================================================
# HOLD TIMER
# =========================================================
func _on_hold_timer_timeout() -> void:
	if player == null:
		return

	if holding_left:
		player.touch_left = true
	elif holding_right:
		player.touch_right = true

# =========================================================
# JUMP
# =========================================================
func _on_jump_button_pressed() -> void:
	if player == null:
		return
	player.touch_jump = true

func _on_jump_button_released() -> void:
	if player == null:
		return
	player.touch_jump = false
