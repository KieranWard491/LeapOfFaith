extends Area2D

@export var camera: Camera2D
@export var distance_below_camera: float = 400.0


func _process(_delta: float) -> void:
	global_position.x = camera.global_position.x
	global_position.y = camera.global_position.y + distance_below_camera


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().reload_current_scene()
