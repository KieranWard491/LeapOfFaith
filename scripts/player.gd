extends CharacterBody2D


@export var max_horizontal_speed: float = 180.0
@export var horizontal_acceleration: float = 700.0
@export var horizontal_friction: float = 900.0
@export var max_jumps: int = 2

const JUMP_VELOCITY: float = -400.0

var jumps_used: int = 0

@onready var sprite: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	# Apply gravity while the frog is airborne.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Restore both jumps when the frog lands.
	if is_on_floor():
		jumps_used = 0

	# Normal jump and double jump.
	if Input.is_action_just_pressed("jump") and jumps_used < max_jumps:
		velocity.y = JUMP_VELOCITY
		jumps_used += 1
		play_bounce_animation()

	# Read horizontal movement input.
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		var target_speed := direction * max_horizontal_speed

		velocity.x = move_toward(
			velocity.x,
			target_speed,
			horizontal_acceleration * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			horizontal_friction * delta
		)

	move_and_slide()


func play_bounce_animation() -> void:
	var tween := create_tween()

	tween.tween_property(
		sprite,
		"scale",
		Vector2(1.45, 0.60),
		0.12
	)

	tween.tween_property(
		sprite,
		"scale",
		Vector2(0.75, 1.40),
		0.14
	)

	tween.tween_property(
		sprite,
		"scale",
		Vector2.ONE,
		0.16
	)
