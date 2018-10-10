extends "res://Scripts/Character.gd"

const MAX_TURN_SPEED = 10 # deg/frame
var motion = Vector2()
onready var torch_node = $Torch
var torch_active

func _ready():
	torch_active = torch_node.enabled

func _process(delta):
	update_motion(delta)
	motion = move_and_slide(motion)
	
func _input(event):
	if Input.is_action_just_pressed("Click"):
		toggle_torch()
	
func update_motion(delta):
	turn_to_mouse()
	
	
	# Read input
	var velocity = Vector2()
	velocity.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	velocity.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	velocity = velocity.normalized() * SPEED
	
	# Apply motion 
	motion += velocity
	
	# Add friction
	if velocity.x == 0:
		motion.x = lerp(motion.x, 0, FRICTION)
	if velocity.y == 0:
		motion.y = lerp(motion.y, 0, FRICTION)
	
	# Limit to max speed
	motion = motion.clamped(MAX_SPEED)


func turn_to_mouse():
	var forward = Vector2.RIGHT.rotated(rotation)
	var mouse_direction = get_global_mouse_position() - position
	var angle_diff = forward.angle_to(mouse_direction)*180/PI
	angle_diff = clamp(angle_diff, -MAX_TURN_SPEED, MAX_TURN_SPEED)
	
	rotation_degrees += angle_diff
	
	# look_at(get_global_mouse_position())

func toggle_torch():
	torch_active = !torch_active
	torch_node.enabled = torch_active
	