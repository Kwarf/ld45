extends Node
class_name GameWorld

onready var player_scn: Node = load("res://scenes/Player.tscn").instance()
onready var map_cell_scn: Node = load("res://scenes/Cell.tscn").instance()
onready var block_scn: Node = load("res://scenes/Block.tscn").instance()

onready var maps: Array = [
	map_cell_scn,
	block_scn
]

var player: Player = null
var current_map: Node = null
var next_map: Node = null
var next_spawn: String = ""

const LEVEL_CHANGE_DELAY = 0.5
const KILL_RESET_DELAY = 0.2

func _ready():
	player = player_scn
	$Player.add_child(player)

#	next_spawn = "Spawn"
#	_set_level(map_cell_scn)
	next_spawn = "Door"
	_set_level(block_scn)

func change_level(name : String, spawn : String) -> void:
	player.allow_input = false
	next_map = _find_level_by_name(name)
	next_spawn = spawn
	# Fade out
	$CanvasLayer/Fade.connect("tween_completed", self, "_on_map_change_fadeout_complete")
	$CanvasLayer/Fade.interpolate_property($CanvasLayer/FadeOut, "color", Color(0, 0, 0, 0), Color.black, LEVEL_CHANGE_DELAY, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$CanvasLayer/Fade.start()

func kill_and_reset_player() -> void:
	# Fade out
	$CanvasLayer/Fade.connect("tween_completed", self, "_on_kill_fadeout_complete")
	$CanvasLayer/Fade.interpolate_property($CanvasLayer/FadeOut, "color", Color(0, 0, 0, 0), Color.black, KILL_RESET_DELAY, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$CanvasLayer/Fade.start()

func _on_kill_fadeout_complete(object : Object, key : NodePath) -> void:
	var spawn = current_map.get_node(next_spawn)
	player.position = spawn.position
	# Fade back
	$CanvasLayer/Fade.disconnect("tween_completed", self, "_on_kill_fadeout_complete")
	$CanvasLayer/Fade.interpolate_property($CanvasLayer/FadeOut, "color", null, Color(0, 0, 0, 0), LEVEL_CHANGE_DELAY, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$CanvasLayer/Fade.start()

func _on_map_change_fadeout_complete(object : Object, key : NodePath) -> void:
	$CanvasLayer/Fade.stop_all()
	if next_map != null:
		_set_level(next_map)

func _find_level_by_name(name : String) -> Node:
	for map in maps:
		if map.name == name:
			return map
	return null

func _set_level(scene : Node):
	# Swap out the map (if any)
	if current_map != null:
		$Map.remove_child(current_map)

	current_map = scene
	$Map.add_child(current_map)

	# Re-position the player
	var spawn = current_map.get_node(next_spawn)
	player.position = spawn.position
	if spawn is Door: # HACK
		player.position.x += 16
		spawn.close()

	# Select camera
	var map_cam = current_map.get_node("Camera2D")
	if map_cam != null:
		map_cam.current = true
		player.get_node("Camera2D").current = false
	else:
		player.get_node("Camera2D").current = true

	# Fade back
	$CanvasLayer/Fade.disconnect("tween_completed", self, "_on_map_change_fadeout_complete")
	$CanvasLayer/Fade.interpolate_property($CanvasLayer/FadeOut, "color", null, Color(0, 0, 0, 0), LEVEL_CHANGE_DELAY, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$CanvasLayer/Fade.start()

	# Reset
	player.allow_input = true
	next_map = null