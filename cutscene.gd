extends Node2D

@export_file("*.tscn") var next_scene_path: String = "game"
@export var trigger_y_position: float = 50  # Y position at top of screen
@onready var rocket = $AnimationPlayer/Rocket  # Adjust to your rocket node

func _process(delta):
	if rocket.global_position.y <= trigger_y_position:
		transition_to_next_scene()

func transition_to_next_scene():
	get_tree().change_scene_to_file(next_scene_path)
