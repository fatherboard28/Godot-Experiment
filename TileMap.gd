extends TileMap


func _ready():
	print_debug("uhh")
	var x : Vector2i = Vector2i(5,5)
	set_cell(0,x,0,Vector2i(0,0))
