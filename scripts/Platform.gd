extends KinematicBody2D

export(Vector2) var distance := Vector2(48, 0)
export(int) var speed := 32

onready var initial_pos: Vector2 = position
onready var tween: Tween = $Tween

func _ready():
	tween.connect("tween_completed", self, "_swap_direction")
	_swap_direction(null, null)
	tween.start()

func _swap_direction(object, key):
	var target = initial_pos + distance
	var duration = distance.length() / speed

	if position.distance_to(target) < 8: # Head back
		tween.interpolate_property(self, "position", target, initial_pos, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	else: # Head out
		tween.interpolate_property(self, "position", initial_pos, target, duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
