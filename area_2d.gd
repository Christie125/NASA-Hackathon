extends Area2D

var player_on_ladder = false
var climbing_speed = 100.0

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_on_ladder = true
		body.set_meta("on_ladder", true)

func _on_body_exited(body):
	if body.name == "Player":
		player_on_ladder = false
		body.set_meta("on_ladder", false)
