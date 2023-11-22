extends CharacterBody2D

@export var controller : Node2D

@export var move_speed: float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@onready var map = get_node("/root/Map")
var pos : Vector2i
var selection : Vector2i




class Direction :
	var up : bool = false
	var down : bool = false
	var left : bool = false
	var right : bool = false
	func clear_all():
		up = false
		down = false
		right = false
		left = false
	func get_dir(dir : Vector2i) -> bool:
		if (dir.x > 0):
			return right
		elif (dir.x < 0):
			return left
		elif (dir.y > 0):
			return down
		else:
			return up
	func set_dir(dir : Vector2i, val : bool):
		if (dir.x > 0):
			right = val
		elif (dir.x < 0):
			left = val
		elif (dir.y > 0):
			down = val
		else:
			up = val
 
var dir : Direction = Direction.new()

func handle_move(direction : Vector2i):
	var tmp = Vector2i(pos.x + direction.x, pos.y + direction.y)
	if (dir.get_dir(direction) && map.map[map.xy_to_index(tmp.x, tmp.y)] == map.tile_type.GRASS):
		pos = tmp
		position = map.tmap.map_to_local(pos)
		dir.set_dir(direction,false)
	else:
		dir.clear_all()
		selection = direction + pos
		map.tmap.clear_layer(2)
		dir.set_dir(direction,true)
		animation_tree.set("parameters/Idle/blend_position", direction)
		map.highlight_selected(tmp)

func _ready():
	var rng = RandomNumberGenerator.new()
	var x : int = 0
	var y : int = 0
	while map.map[map.xy_to_index(x,y)] != map.tile_type.GRASS:
		x = rng.randi_range(0,8)
		y = rng.randi_range(0,8)
	pos = Vector2i(x,y)
	position = map.tmap.map_to_local(pos)
	animation_tree.set("parameters/Idle/blend_position", Vector2(0,1))

func _physics_process(_delta):
	if (Input.is_action_just_pressed("down")):
		handle_move(Vector2i(0,1))
	if (Input.is_action_just_pressed("up")):
		handle_move(Vector2i(0,-1))
	if (Input.is_action_just_pressed("left")):
		handle_move(Vector2i(-1,0))
	if (Input.is_action_just_pressed("right")):
		handle_move(Vector2i(1,0))
	if (Input.is_action_just_pressed("harvest")):
		var type = map.harvest_resource(selection)
		match type:
			map.tile_type.TREE:
				controller.update_ui_num(1)
				
		selection = Vector2i.ZERO
		dir.clear_all()
		map.tmap.clear_layer(2)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
