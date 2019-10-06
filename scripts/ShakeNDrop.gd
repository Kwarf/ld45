extends Node2D

export(NodePath) var trigger
export(NodePath) var target
export(bool) var should_reset = true

onready var initial_position := position

var body_in_trigger = false
var triggered = false

func _ready() -> void:
	var t = get_node(trigger)
	assert t is Area2D

	# Set up the fall trigger
	t.connect("body_entered", self, "_on_trigger_entered")
	t.connect("body_exited", self, "_on_trigger_exited")
	$Tween.connect("tween_completed", self, "_on_fallen")

	# Set up the killzone
	$Killzone.connect("body_entered", self, "_on_spike_touched")

func _physics_process(delta) -> void:
	if not body_in_trigger:
		return

	if not triggered and position == initial_position:
		triggered = true
		var ty = position.y + get_node(target).position.y
		$Tween.interpolate_property(self, "position", null, Vector2(position.x, ty), 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN)
		$Tween.start()

func _on_trigger_entered(body : PhysicsBody2D) -> void:
	var player := body as Player
	if player != null:
		body_in_trigger = true

func _on_trigger_exited(body : PhysicsBody2D) -> void:
	var player := body as Player
	if player != null:
		body_in_trigger = false

func _on_fallen(object : Object, key : NodePath) -> void:
	if triggered and should_reset:
		$AudioStreamPlayer2D.play()
		var map = get_viewport().get_node("World/Map")
		var world_cam = map.find_node("Camera2D", true, false)
		if world_cam != null:
			world_cam.add_trauma(0.5)
		else:
			get_viewport().get_node("World/Player/Player/Camera2D").add_trauma(0.5)

		triggered = false
		$Tween.interpolate_property(self, "position", null, initial_position, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()

func _on_spike_touched(body : PhysicsBody2D) -> void:
	var world: GameWorld = get_viewport().get_node("World") as GameWorld
	var player := body as Player
	if player != null:
		world.kill_and_reset_player()