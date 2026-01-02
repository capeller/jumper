extends Node2D

# =========================================================
# DIFFICULTY PROGRESSION SETTINGS
# =========================================================

@export var difficulty_step_time: float = 7.0   # Increase difficulty every X seconds
@export var speed_increment: float = 10.0        # How much platform speed increases
@export var min_spawn_interval: float = 0.6      # Minimum allowed spawn interval


# =========================================================
# PLATFORM SETTINGS
# =========================================================

@export var platform_scene: PackedScene

# Where platforms will be added (assign the "Platforms" Node2D in the Inspector)
@export var platforms_container_path: NodePath

@export var spawn_interval: float = 1.1
@export var speed_factor: float = 160.0

@export var initial_platform_count: int = 3


# =========================================================
# VERTICAL GAP SETTINGS
# =========================================================

# Initial gaps (1->2 and 2->3)
@export var first_gap: float = 100.0
@export var second_gap: float = 120.0

# Normal gap after the initial platforms
@export var min_vertical_gap: float = 30.0
@export var max_vertical_gap: float = 50.0


# =========================================================
# START PLATFORM SETTINGS
# =========================================================

@export var start_platform_height_ratio: float = 0.25


# =========================================================
# INTERNAL STATE
# =========================================================

var platform_speed: float
var columns_x: Array[float] = []
var last_column_index: int = -1
var spawning: bool = false

var spawn_cursor_y: float
var spawned_count: int = 0

var elapsed_time: float = 0.0

var platforms_container: Node2D


# =========================================================
# INITIALIZATION
# =========================================================

func _ready() -> void:
	calculate_columns()
	platform_speed = spawn_interval * speed_factor

	platforms_container = get_node_or_null(platforms_container_path) as Node2D
	if platforms_container == null:
		push_error(
			"PlatformSpawner: platforms_container_path is not set or invalid. "
			+ "Please assign the 'Platforms' Node2D in the Inspector."
		)


# =========================================================
# DIFFICULTY PROGRESSION (TIME-BASED)
# =========================================================

func _process(delta: float) -> void:
	if not spawning:
		return

	elapsed_time += delta

	if elapsed_time >= difficulty_step_time:
		elapsed_time = 0.0
		increase_difficulty()


func increase_difficulty() -> void:
	# Increase platform falling speed
	platform_speed += speed_increment

	# Decrease spawn interval, respecting the minimum limit
	spawn_interval = max(min_spawn_interval, spawn_interval - 0.1)

	# Apply the new speed to all existing platforms (optional but recommended)
	for platform in platforms_container.get_children():
		platform.speed = platform_speed

# =========================================================
# INITIAL PLATFORM SPAWN
# =========================================================

func spawn_initial_platforms() -> Array[Node2D]:
	var result: Array[Node2D] = []

	if platform_scene == null:
		push_error("PlatformSpawner: platform_scene is NOT set in the Inspector.")
		return result

	if platforms_container == null:
		push_error("PlatformSpawner: Platforms container not found.")
		return result

	var first := spawn_start_platform()
	if first == null:
		return result

	result.append(first)

	# Spawn additional initial platforms immediately
	while result.size() < initial_platform_count:
		var p := spawn_platform()
		if p == null:
			break
		result.append(p)

	return result


func spawn_start_platform() -> Node2D:
	var platform := _instantiate_platform()
	if platform == null:
		return null

	var col := pick_column_index()
	var x := columns_x[col]

	var viewport_height := get_viewport_rect().size.y
	var y := viewport_height * start_platform_height_ratio

	platform.global_position = Vector2(x, y)
	_set_platform_speed(platform)

	last_column_index = col
	spawn_cursor_y = y
	spawned_count = 1

	platforms_container.add_child(platform)
	return platform


# =========================================================
# CONTINUOUS PLATFORM SPAWN
# =========================================================

func spawn_platform() -> Node2D:
	var platform := _instantiate_platform()
	if platform == null:
		return null

	var col := pick_column_index()
	var x := columns_x[col]

	var gap: float
	if spawned_count == 1:
		gap = first_gap
	elif spawned_count == 2:
		gap = second_gap
	else:
		gap = randf_range(min_vertical_gap, max_vertical_gap)

	spawn_cursor_y -= gap

	platform.global_position = Vector2(x, spawn_cursor_y)
	_set_platform_speed(platform)

	last_column_index = col
	spawned_count += 1

	platforms_container.add_child(platform)
	return platform


func start_spawning() -> void:
	if spawning:
		return

	spawning = true
	elapsed_time = 0.0
	spawn_loop()


func stop_spawning() -> void:
	spawning = false


func spawn_loop() -> void:
	while spawning:
		# If the initial platform was not created yet, wait
		if spawned_count == 0:
			await get_tree().process_frame
			continue

		if not spawning:
			break

		spawn_platform()
		await get_tree().create_timer(spawn_interval).timeout


# =========================================================
# COLUMN LOGIC
# =========================================================

func calculate_columns() -> void:
	var w := get_viewport_rect().size.x
	columns_x = [
		w * 0.25,
		w * 0.50,
		w * 0.75
	]


func pick_column_index() -> int:
	# First platform: any column
	if last_column_index == -1:
		return randi() % columns_x.size()

	var options: Array[int] = []

	for i in range(columns_x.size()):
		var delta: int = abs(i - last_column_index)

		# Enforce alternating columns (adjacent only)
		if delta == 1:
			options.append(i)

	# Safety fallback
	if options.is_empty():
		for i in range(columns_x.size()):
			if i != last_column_index:
				options.append(i)

	# Explicit random selection (no pick_random)
	var idx := randi() % options.size()
	return options[idx]


# =========================================================
# HELPERS
# =========================================================

func _instantiate_platform() -> Node2D:
	if platform_scene == null:
		push_error("PlatformSpawner: platform_scene is null.")
		return null

	var node := platform_scene.instantiate()
	var platform := node as Node2D

	if platform == null:
		push_error("PlatformSpawner: instantiated scene is not a Node2D.")
		return null

	return platform


func _set_platform_speed(platform: Node) -> void:
	platform.speed = platform_speed
