extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 1.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func _ready():
	# Start the shake once the scene is ready
	apply_shake()

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()
	else:
		offset = Vector2.ZERO

func apply_shake() -> void:
	shake_strength = randomStrength

func randomOffset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)
