extends Node2D

func _ready() -> void:
	$Killzone.connect("body_entered", self, "_on_spike_touched")

func _on_spike_touched(body : PhysicsBody2D) -> void:
	var world: GameWorld = get_viewport().get_node("World") as GameWorld
	var player := body as Player
	if player != null:
		world.kill_and_reset_player()