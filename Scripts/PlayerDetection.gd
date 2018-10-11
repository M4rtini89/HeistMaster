extends "res://Scripts/Character.gd"

const FOV_TOLERANCE = deg2rad(20)
const MAX_DETECTION_RANGE = 320

const RED = Color(1, .25, .25)
const WHITE = Color.white

onready var Player = get_node("/root/Level/Player") # Make this level neutral
onready var Torch = get_node("Torch/Light")

var player_in_fov = false

func _process(delta):
	if player_in_fov and Player_is_in_LOS():
		Torch.color = RED
	else:
		Torch.color = WHITE
	

func Player_is_in_FOV_TOLERANCE():
	var NPC_facing_direction = Vector2.RIGHT.rotated(global_rotation)
	var direction_to_player = (Player.position - global_position).normalized()
	var angle_to_player = abs(direction_to_player.angle_to(NPC_facing_direction))
	
	if angle_to_player < FOV_TOLERANCE:
		return true
	else:
		return false
		


func Player_is_in_LOS():
	var space = get_world_2d().direct_space_state
	var LOS_obstacle = space.intersect_ray(global_position, Player.position, [self], collision_mask)
	
	if LOS_obstacle.collider == Player:
		return true
	else:
		return false


func _on_Torch_body_entered(body):
	player_in_fov = true


func _on_Torch_body_exited(body):
	player_in_fov = false
