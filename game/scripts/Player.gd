extends CharacterBody2D

@export var speed: float = 500.0
@export var jump_force: float = 1400.0
@export var gravity: float = 1600.0
@export var gravity_up := 1400.0
@export var gravity_down := 2000.0

@export var max_health: int = 1   # Immediate death on fall

@export var texture_right: Texture2D
@export var texture_left: Texture2D

@onready var sprite: Sprite2D = $Sprite

signal died

var health: int

func _ready() -> void:
	health = max_health
	add_to_group("player")

	if texture_right:
		sprite.texture = texture_right

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	var dir := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = dir * speed

	if dir > 0 and texture_right:
		sprite.texture = texture_right
	elif dir < 0 and texture_left:
		sprite.texture = texture_left

	if velocity.y < 0:
		velocity.y += gravity_up * delta
	else:
		velocity.y += gravity_down * delta

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force

	move_and_slide()

func die() -> void:
	emit_signal("died")
	queue_free()
