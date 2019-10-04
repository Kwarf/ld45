# 2D adaptation by me of a scripy by
# https://www.reddit.com/user/Dogpot
# https://pastebin.com/pSV9vVP1
# which was itself is a modification of original scripy by
# https://twitter.com/_Azza292
# https://pastebin.com/pjxjqyrK

# MIT License

extends Camera2D

# exported parameters
export var speed := 1.0
export var decay_rate := 0.8
export var max_offset := 4

# default values
onready var start_position := offset
var trauma := 0.0
var time := 0.0
var noise := OpenSimplexNoise.new()
var noise_seed := randi()

# configure noise
func _init() -> void:
	noise.seed = noise_seed
	noise.octaves = 1
	noise.period = 256.0
	noise.persistence = 0.5
	noise.lacunarity = 1.0

# apply shake if there's any trauma
func _process(delta: float) -> void:
	if trauma > 0.0:
		_decay_trauma(delta)
		_apply_shake(delta)

# add trauma to start/continue the shake
func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

# decay the trauma effect over time
func _decay_trauma(delta: float) -> void:
	var change := decay_rate * delta
	trauma = max(trauma - change, 0.0)

# apply shake to starting camera position
func _apply_shake(delta: float) -> void:
	# using a magic number here to get a pleasing effect at speed 1.0
	time += delta * speed * 5000.0
	var shake := trauma * trauma
	var offset_x := max_offset * shake * get_noise_value(noise_seed + 1, time)
	var offset_y := max_offset * shake * get_noise_value(noise_seed + 2, time)
	offset = start_position + Vector2(offset_x, offset_y)

# return a random float in range(-1, 1) using OpenSimplex noise
func get_noise_value(seed_value: int, time: int) -> float:
	noise.seed = seed_value
	return noise.get_noise_2d(time, time)