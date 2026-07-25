extends Node2D


@export var platform_scene: PackedScene
@export var starting_platform: Node2D
@export var camera: Camera2D

@export var initial_platform_count: int = 12

@export var minimum_vertical_gap: float = 45.0
@export var maximum_vertical_gap: float = 70.0

@export var maximum_horizontal_gap: float = 140.0

@export var minimum_x_position: float = 100.0
@export var maximum_x_position: float = 1050.0

@export var despawn_distance: float = 450.0


var platforms: Array[Node2D] = []

var highest_platform_y: float
var previous_platform_x: float


func _ready() -> void:
	randomize()

	highest_platform_y = starting_platform.global_position.y
	previous_platform_x = starting_platform.global_position.x

	platforms.append(starting_platform)

	for i in range(initial_platform_count):
		spawn_platform()


func _process(_delta: float) -> void:
	remove_old_platforms()


func spawn_platform() -> void:
	var new_platform := platform_scene.instantiate() as Node2D

	add_child(new_platform)

	var vertical_gap := randf_range(
		minimum_vertical_gap,
		maximum_vertical_gap
	)

	var horizontal_change := randf_range(
		-maximum_horizontal_gap,
		maximum_horizontal_gap
	)

	var new_x := previous_platform_x + horizontal_change

	new_x = clamp(
		new_x,
		minimum_x_position,
		maximum_x_position
	)

	var new_y := highest_platform_y - vertical_gap

	new_platform.global_position = Vector2(new_x, new_y)

	platforms.append(new_platform)

	previous_platform_x = new_x
	highest_platform_y = new_y


func remove_old_platforms() -> void:
	for platform in platforms.duplicate():
		if not is_instance_valid(platform):
			platforms.erase(platform)
			continue

		var platform_is_below_camera: bool = (
			platform.global_position.y >
			camera.global_position.y + despawn_distance
		)

		if platform_is_below_camera:
			platforms.erase(platform)
			platform.queue_free()

			spawn_platform()
