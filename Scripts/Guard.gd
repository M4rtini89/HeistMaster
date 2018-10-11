extends "res://Scripts/PlayerDetection.gd"

var motion = Vector2()
var possible_destinations = []
var path = []
var destination = Vector2()

export var walk_slowdown = 0.5
export var navigation_stop_distance = 5

onready var navigation = Global.navigation
onready var available_destinations = Global.destinations
onready var timer = $Timer

func _ready():
	possible_destinations = available_destinations.get_children()
	make_path()


func _process(delta):
	navigate()


func navigate():
	var distance_to_destination = position.distance_to(path[0])
	destination = path[0]
	
	if distance_to_destination > navigation_stop_distance:
		move()
	else:
		update_path()


func move():
	look_at(destination)
	motion = (destination - position).normalized() * (MAX_SPEED * walk_slowdown)
	
	move_and_slide(motion)
	
	if is_on_wall():
		make_path()


func update_path():
	if path.size() == 1:
		if timer.is_stopped():
			timer.start()
	else:
		path.remove(0)


func make_path():
	randomize()
	var next_destination = possible_destinations[randi() % possible_destinations.size()]
	
	path = navigation.get_simple_path(global_position, next_destination.global_position, false)

func _on_Timer_timeout():
	make_path()
