extends Node2D
class_name Door

export(String) var target_map
export(String) var target_spawn := "Spawn"

func close():
	$AnimationPlayer.play_backwards("Open")

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_in_proximity")
	$Area2D.connect("body_exited", self, "_on_body_left")

func _physics_process(delta):
	if not $InteractIndicator.visible:
		return

	if Input.is_action_pressed("interact"):
		$AnimationPlayer.play("Open")
		get_viewport().get_node("World").change_level(target_map, target_spawn)

func _on_body_in_proximity(body : PhysicsBody2D):
	var player := body as Player
	if player != null:
		$InteractIndicator.visible = true

func _on_body_left(body : PhysicsBody2D):
	var player := body as Player
	if player != null:
		$InteractIndicator.visible = false