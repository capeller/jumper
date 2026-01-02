extends Area2D

@export var spin_speed: float = 6.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	rotation += spin_speed * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		GameManager.add_coin(1)
		queue_free()
