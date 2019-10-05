extends Node
class_name GameWorld

onready var player_scn: PackedScene = preload("res://scenes/Player.tscn")
onready var map_cell_scn: PackedScene = preload("res://scenes/Cell.tscn")
onready var block_scn: PackedScene = preload("res://scenes/Block.tscn")

onready var maps: Array = [
	map_cell_scn,
	block_scn
]

var player: Player = null
var current_map: Node = null
var next_map: PackedScene = null
var next_spawn: String = ""

const LEVEL_CHANGE_DELAY = 0.5

func _ready():
	player = player_scn.instance()
	$Player.add_child(player)

	next_spawn = "Spawn"
	_set_level(map_cell_scn)

	$CanvasLayer/Fade.connect("tween_completed", self, "_on_fadeout_complete")

func change_level(name : String, spawn : String) -> void:
	player.allow_input = false
	next_map = _find_level_by_name(name)
	next_spawn = spawn
	$CanvasLayer/Fade.interpolate_property($CanvasLayer/FadeOut, "color", Color(0, 0, 0, 0), Color.black, LEVEL_CHANGE_DELAY, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$CanvasLayer/Fade.start()

func _on_fadeout_complete(object : Object, key : NodePath):
	$CanvasLayer/Fade.stop_all()
	if next_map != null:
		_set_level(next_map)

func _find_level_by_name(name : String) -> PackedScene:
	for map in maps:
		if (map as PackedScene).resource_path == name:
			return map
	return null

func _set_level(scene : PackedScene):
	# Swap out the map (if any)
	if current_map != null:
		current_map.queue_free()
		remove_child(current_map)

	current_map = scene.instance()
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
	$CanvasLayer/Fade.interpolate_property($CanvasLayer/FadeOut, "color", null, Color(0, 0, 0, 0), LEVEL_CHANGE_DELAY, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$CanvasLayer/Fade.start()

	# Reset
	player.allow_input = true
	next_map = null