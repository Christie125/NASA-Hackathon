extends Area2D

@export_multiline var sign_text: String = "In this level, you will experience weightlessness in a simulated pool.\nYour equipment gear is carefully calibrated so that you are perfectly buoyant in the water.\nYou will have to complete 3 tasks on the Model Space Station, mimicking real space walks.\nIn real astronaut trainings, the astronaut is moved throughout the water by a team of expert divers to train astronauts for the real experience (You cannot swim in space as there is nothing to push off of).\nFor this game however, you can move freely throughout the pool however you please.\nComplete the 3 tasks and get ready to blast into space!"
@export var typing_speed: float = 0.0
var text_lines = []
var current_line_index = 0
var is_typing = false
var player_in_range = false
var sign_active = false

@onready var text_label = $CanvasLayer/Control/Panel/TextLabel
@onready var prompt_label = $CanvasLayer/Control/Panel/PromptLabel
@onready var panel = $CanvasLayer/Control/Panel

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer.process_mode = Node.PROCESS_MODE_ALWAYS
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	text_lines = sign_text.split("\n")
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
