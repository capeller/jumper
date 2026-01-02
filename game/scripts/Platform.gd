extends Node2D

@export var speed: float = 0.0

@export var coin_scene: PackedScene
@export var coin_height_offset: float = 40.0
@export var spawn_coin: bool = true

# How far above the bottom of the screen the platform should be removed
@export var despawn_offset: float = 260.0


func _ready() -> void:
	if spawn_coin and coin_scene:
		var coin = coin_scene.instantiate()
		add_child(coin)

		# Centered and positioned above the platform
		coin.position = Vector2(0, -coin_height_offset)


func _process(delta: float) -> void:
	position.y += speed * delta

	var screen_height := get_viewport_rect().size.y

	# Remove the platform before it reaches the bottom of the screen
	if global_position.y > screen_height - despawn_offset:
		queue_free()
