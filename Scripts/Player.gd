extends "res://Scripts/Character.gd"

var motion = Vector2()


func _process(delta):
	update_motion(delta)
	motion = move_and_slide(motion)
	
func update_motion(delta):
	look_at(get_global_mouse_position())
	
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
	