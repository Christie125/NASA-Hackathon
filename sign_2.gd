extends Area2D

@export_multiline var incomplete_text: String = "Complete all 3 tasks first!\nWire Connection\nDial Calibration\nSimon Says Memory"
@export_multiline var complete_text: String = "Great Job!\nYou now know how astronauts train for weightlessness on space walks.\nRemember, the real process is much more complex and requires extensive tests and safety measures.\nThis training process helps prevent injuries and accidents in space which can be costly.\nBy training in pools first, astronauts get a feel of the weightlessness of space and become ready to perform tasks.\nBy maintaining the ISS, these astronauts maintain the helpful tools and data that it provides humanity.\nNonetheless, get ready for blast off!"
@export var typing_speed: float = 0.05

var text_lines = []
var current_line_index = 0
var is_typing = false
var player_in_range = false
var sign_active = false

@onready var text_label = $CanvasLayer/Control/Panel/TextLabel
@onready var prompt_label = $CanvasLayer/Control/Panel/PromptLabel
@onready var panel = $CanvasLayer/Control/Panel
@onready var TaskTracker: Node = $"../TaskTracker"

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer.process_mode = Node.PROCESS_MODE_ALWAYS
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	panel.visible = false

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		if not sign_active:
			print("Press E to read sign")

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		close_sign()

func _unhandled_input(event):
	if sign_active:
		if event.is_action_pressed("ui_accept"):
			get_viewport().set_input_as_handled()
			if not is_typing:
				next_line()
	elif player_in_range:
		if event.is_action_pressed("ui_accept"):
			open_sign()

func open_sign():
	sign_active = true
	panel.visible = true
	current_line_index = 0
	text_label.text = ""
	get_tree().paused = true
	
	# Choose text based on task completion
	var sign_text = incomplete_text
	if TaskTracker.all_tasks_done():
		sign_text = complete_text
	
	print("Tasks completed: ", TaskTracker.tasks_completed, "/", TaskTracker.total_tasks)
	print("Using complete text: ", TaskTracker.all_tasks_done())
	
	text_lines = sign_text.split("\n")
	show_line()

func show_line():
	if current_line_index >= text_lines.size():
		await get_tree().create_timer(0.5).timeout
		close_sign()
		return
	
	is_typing = true
	prompt_label.visible = false
	
	var line = text_lines[current_line_index]
	text_label.text = ""
	
	for i in range(line.length()):
		text_label.text += line[i]
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false
	prompt_label.visible = true

func next_line():
	current_line_index += 1
	show_line()

func close_sign():
	sign_active = false
	panel.visible = false
	get_tree().paused = false
	current_line_index = 0
