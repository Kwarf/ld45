extends Node2D
class_name Door

export(String) var target_map
export(String) var target_spawn := "Spawn"
export(bool) var locked := false
export(bool) var interactable := true
export(bool) var outdoor := false

signal interacted

var player: Player = null

func open():
	$OpenSound.play()
	$AnimationPlayer.play("Open")
	get_viewport().get_node("World").change_level(target_map, target_spawn)

func close():
	$AnimationPlayer.play_backwards("Open")

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_in_proximity")
	$Area2D.connect("body_exited", self, "_on_body_left")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	if outdoor:
		$AnimationPlayer.play("Outdoor")

func _physics_process(delta):
	if player == null or not player.allow_input:
		return

	if Input.is_action_just_pressed("interact"):
		emit_signal("interacted")
		if interactable:
			if not locked or player.has_key:
				if not outdoor:
					open()
				else:
					get_viewport().get_node("World").victory()
			else:
				var tie = get_viewport().get_node("World").find_node("TextInterfaceEngine") as TextInterfaceEngine
				tie.buff_text("It's locked... If only I had a key...", 0.03)
				tie.set_state(tie.STATE_OUTPUT)

func _on_body_in_proximity(body : PhysicsBody2D) -> void:
	var player := body as Player
	if player != null:
		self.player = player
		$InteractIndicator.visible = true


func _on_body_left(body : PhysicsBody2D) -> void:
	var player := body as Player
	if player != null:
		self.player = null
		$InteractIndicator.visible = false

func _on_animation_finished(name : String) -> void:
	if name != "Outdoor":
		$ClosedSound.play()