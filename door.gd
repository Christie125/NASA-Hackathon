extends Area2D

@export_file("*.tscn") var next_scene_path: String = "cutscene"
var player_in_range = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		print("Press E to enter door")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _input(event):
	if player_in_range and event.is_action_pressed("ui_accept"):
		transition_to_next_scene()

func transition_to_next_scene():
	if next_scene_path == "":
		print("ERROR: No scene path set in door!")
		return
	
	print("Transitioning to: ", next_scene_path)
	get_tree().change_scene_to_file(next_scene_path)
