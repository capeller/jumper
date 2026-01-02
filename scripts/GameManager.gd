extends Node

signal coins_changed(total: int)

var coins: int = 0
var score: int = 0

func add_coin(amount: int = 1) -> void:
	coins += amount
	score = coins
	emit_signal("coins_changed", coins)

func reset() -> void:
	coins = 0
	score = 0
	emit_signal("coins_changed", coins)
