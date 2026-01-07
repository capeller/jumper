class_name Player
extends CharacterBody2D

# =========================================================
# MOVEMENT CONFIG
# =========================================================
@export var speed: float = 500.0
@export var jump_force: float = 1150.0

# =========================================================
# GRAVITY CONFIG
# =========================================================
@export var gravity: float = 1600.0 # (mantido por compatibilidade)
@export var gravity_up: float = 2200.0
@export var gravity_down: float = 2800.0

# =========================================================
# JUMP BUFFER CONFIG
# =========================================================
@export var jump_buffer_time: float = 0.15
var jump_buffer: float = 0.0

# =========================================================
# PLAYER STATE
# =========================================================
@export var max_health: int = 1

@export var texture_right: Texture2D
@export var texture_left: Texture2D

@onready var sprite: Sprite2D = $Sprite

signal died

var health: int

# =========================================================
# TOUCH INPUT (setado pelo HUD)
# =========================================================
var touch_left := false
var touch_right := false
var touch_jump := false

func _ready() -> void:
	health = max_health
	add_to_group("player")

	if texture_right:
		sprite.texture = texture_right

func _physics_process(delta: float) -> void:
	# -----------------------------------------------------
	# HORIZONTAL INPUT (keyboard + touch)
	# -----------------------------------------------------
	var dir := 0
	if Input.is_action_pressed("move_left") or touch_left:
		dir -= 1
	if Input.is_action_pressed("move_right") or touch_right:
		dir += 1

	velocity.x = dir * speed

	# -----------------------------------------------------
	# JUMP BUFFER (keyboard + touch)
	# -----------------------------------------------------
	if Input.is_action_just_pressed("jump") or touch_jump:
		jump_buffer = jump_buffer_time
		touch_jump = false
	else:
		jump_buffer -= delta

	# -----------------------------------------------------
	# APPLY JUMP
	# -----------------------------------------------------
	if is_on_floor() and jump_buffer > 0.0:
		velocity.y = -jump_force
		jump_buffer = 0.0

	# -----------------------------------------------------
	# GRAVITY
	# -----------------------------------------------------
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += gravity_up * delta
		else:
			velocity.y += gravity_down * delta

	# -----------------------------------------------------
	# SPRITE DIRECTION
	# -----------------------------------------------------
	if dir > 0 and texture_right:
		sprite.texture = texture_right
	elif dir < 0 and texture_left:
		sprite.texture = texture_left

	move_and_slide()

func die() -> void:
	emit_signal("died")
	queue_free()
