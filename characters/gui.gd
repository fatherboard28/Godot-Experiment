extends CanvasLayer
class_name UI

@onready var map = get_node("/root/Map")
@onready var wood_label = %number
@onready var gen_world = %gen_world
@onready var player = get_node("/root/GameLevel/player") 

var wood_num = 0

func update_score(val):
	wood_num += val
	wood_label.text = str(wood_num) 


func _on_gen_world_pressed():
	map.create_world()
	player.spawn_player()

