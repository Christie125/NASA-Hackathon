extends Area2D
@onready var TaskTracker: Node = $"../../TaskTracker"

var player_in_range = false
var task_completed = false
var task_scene = preload("res://Tasks/simon_task.tscn")  # Change this path for each task

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player" and not task_completed:
		player_in_range = true
		print("Press E to start task")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false

func _input(event):
	if player_in_range and not task_completed and event.is_action_pressed("ui_accept"):
		open_task()

func open_task():
	var task = task_scene.instantiate()
	task.task_completed.connect(_on_task_completed)
	get_tree().root.add_child(task)
	get_tree().paused = true

func _on_task_completed():
	task_completed = true
	
	# THIS IS THE IMPORTANT LINE - Call TaskTracker
	TaskTracker.complete_task()
	
	print("Task done!")
	
	# Delete exclamation mark if it's the parent
	if get_parent():
		get_parent().queue_free()
