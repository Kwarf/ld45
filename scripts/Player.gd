extends KinematicBody2D

const GRAVITY = 500
const X_FORCE = 1000
const X_SPEED_MAX = 100
const R_FORCE = 1000
const J_VELOCITY = 150

var velocity = Vector2()

func _physics_process(delta):
	var force = Vector2(0, GRAVITY)
	var has_input = false

	# Movement
	if Input.is_action_pressed("left") and velocity.x > -X_SPEED_MAX:
		force.x -= X_FORCE
		has_input = true
	if Input.is_action_pressed("right") and velocity.x < X_SPEED_MAX:
		force.x += X_FORCE
		has_input = true
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -J_VELOCITY

	# Slowing down
	if not has_input:
		velocity.x = max(0, abs(velocity.x) - R_FORCE * delta) * sign(velocity.x)

	# Animation selection
	if abs(velocity.x) == 0 or not is_on_floor():
		$AnimationPlayer.play("Idle")
	elif is_on_floor():
		$AnimationPlayer.play("Running")
		$Sprite.flip_h = velocity.x < 0

	velocity += force * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))