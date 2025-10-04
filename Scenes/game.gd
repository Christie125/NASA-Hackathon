extends Node2D

var user_score = 0
var tries_left = 48
var images = []
var correct_button

func _ready():
	images = [$Himalayas, $Pyramids, $Canyonwebp]
	correct_button = $Canyonwebp

	for button in images:
		button.pressed.connect(_on_image_pressed.bind(button))

	$CanvasLayer/text1.visible = false
	$CanvasLayer/text2.visible = false
	$CanvasLayer/text3.visible = false
	$CanvasLayer/text4.visible = false
	$"CanvasLayer/you-won".visible = false
	$"CanvasLayer/YOU-LOST".visible=false

	print("about to show intrcutions")
	show_instructions()


func show_instructions():
	$CanvasLayer/text1.visible = true
	await get_tree().create_timer(4.0).timeout
	$CanvasLayer/text1.visible = false
	$CanvasLayer/text2.visible = true
	await get_tree().create_timer(4.0).timeout
	$CanvasLayer/text2.visible = false
	$CanvasLayer/text3.visible = true
	await get_tree().create_timer(4.0).timeout
	$CanvasLayer/text3.visible = false
	$CanvasLayer/text4.visible = true
	await get_tree().create_timer(4.0).timeout
	$CanvasLayer/text4.visible = false
	
	print("about to start game")
	#starts actual game
	show_random_image()


func show_random_image():
	for button in images:
		button.visible = false

	var chosen = images.pick_random()
	chosen.visible = true

	tries_left -= 1

	if tries_left > 0:
		await get_tree().create_timer(0.6).timeout
		show_random_image()
	else:
		for button in images:
			button.visible = false
		check_result()


func _on_image_pressed(button: TextureButton):
	if button == correct_button:
		user_score += 1
		print("canyon pressed!")


func check_result():
	if user_score >= 3:
		print("You won!")
		$"CanvasLayer/you-won".visible=true
	else:
		print("You lost!")
		print(user_score)
		$"CanvasLayer/YOU-LOST".visible=true
