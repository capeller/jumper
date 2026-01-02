extends CanvasLayer

@onready var coins_label: Label = $TopLeft/Coins
@onready var game_over_panel: Control = $GameOver
@onready var coins_result: Label = $GameOver/Panel/VBox/CoinsResult

func _ready() -> void:
	coins_label.text = "Coins: 0"
	game_over_panel.visible = false

	GameManager.coins_changed.connect(_on_coins_changed)

func _on_coins_changed(total: int) -> void:
	coins_label.text = "Coins: %d" % total

func show_game_over() -> void:
	coins_result.text = "Coins collected: %d" % GameManager.coins
	game_over_panel.visible = true
