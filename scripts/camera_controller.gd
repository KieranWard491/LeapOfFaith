extends Camera2D

@export var player: CharacterBody2D

var highest_y: float


func _ready() -> void:
	highest_y = player.global_position.y
	global_position.x = player.global_position.x
	global_position.y = highest_y


func _process(_delta: float) -> void:
	global_position.x = player.global_position.x

	if player.global_position.y < highest_y:
		highest_y = player.global_position.y
		global_position.y = highest_y
