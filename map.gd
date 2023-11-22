extends Node
@onready var tmap = get_node("TileMap")
# 0  1  2  3  4  5  6  7  8 
# 9  10 11 12 13 14 15 16 17 
# 18 19 20 21 22 23 24 25 26 
# 27 28 29 30 31 32 33 34 35 
# 36 37 38 39 40 41 42 43 44 
# 45 46 47 48 49 50 51 52 53 
# 54 55 56 57 58 59 60 61 62 
# 63 64 65 66 67 68 69 70 71 
# 72 73 74 75 76 77 78 79 80
enum tile_type {GRASS, WATER, TREE, ROCK, DEEPWATER}
var map = []

class Add_Tile_Data:
	var pos : Vector2i
	var type : tile_type
	func _init(p : Vector2i, t : tile_type):
		pos = p
		type = t


func xy_to_index(row : int, column : int):
	return (column * 9) + row
	
func gen_world():
	for x in 10:
		for y in 10:
			map.append(tile_type.GRASS)
			tmap.set_cell(0, Vector2i(x,y), 0, Vector2i(0,0))
			
			
func highlight_selected(pos : Vector2i):
	match map[xy_to_index(pos.x, pos.y)]:
		tile_type.GRASS:
			tmap.set_cell(2, pos, 1, Vector2i(7,1))
		tile_type.TREE:
			tmap.set_cell(2, pos, 3, Vector2i(1,2))
		tile_type.WATER, tile_type.DEEPWATER:
			tmap.set_cell(2, pos, 2, Vector2i(2,3))
		
	
func place_trees():
	var rng = RandomNumberGenerator.new()
	for x in rng.randi_range(8,20):
		var col = rng.randi_range(0,8)
		var row = rng.randi_range(0,8)
		place_tile(Vector2i(col, row), tile_type.TREE)
	
func place_water():
	var rng = RandomNumberGenerator.new()
	var water_seed : Vector2i = Vector2i(rng.randi_range(1,7),rng.randi_range(1,7))
	
	var tile_to_add : Array[Add_Tile_Data]
	tile_to_add.append(Add_Tile_Data.new(water_seed, tile_type.WATER))
	
	for y in rng.randi_range(1,4):
		tile_to_add.append(Add_Tile_Data.new(Vector2i(water_seed.x, water_seed.y-y), tile_type.WATER))
	for y in rng.randi_range(1,4):
		tile_to_add.append(Add_Tile_Data.new(Vector2i(water_seed.x, water_seed.y+y), tile_type.WATER))
	for x in rng.randi_range(1,4):
		tile_to_add.append(Add_Tile_Data.new(Vector2i(water_seed.x-x, water_seed.y), tile_type.WATER))
	for x in rng.randi_range(1,4):
		tile_to_add.append(Add_Tile_Data.new(Vector2i(water_seed.x+x, water_seed.y), tile_type.WATER))
		
	tile_to_add.append(Add_Tile_Data.new(Vector2i(water_seed.x+1, water_seed.y+1), tile_type.WATER))
	tile_to_add.append(Add_Tile_Data.new(Vector2i(water_seed.x-1, water_seed.y+1), tile_type.WATER))
	tile_to_add.append(Add_Tile_Data.new(Vector2i(water_seed.x+1, water_seed.y-1), tile_type.WATER))
	tile_to_add.append(Add_Tile_Data.new(Vector2i(water_seed.x-1, water_seed.y-1), tile_type.WATER))
	
	for x in tile_to_add.size():
		place_tile(tile_to_add[x].pos, tile_to_add[x].type)
	
func harvest_resource(pos : Vector2i) -> tile_type:
	if (map[xy_to_index(pos.x, pos.y)] == tile_type.TREE):
		tmap.set_cell(1, pos, -1, Vector2i(-1,-1))
		map[xy_to_index(pos.x, pos.y)] = tile_type.GRASS
		return tile_type.TREE
	return -1
		
func place_tile(pos : Vector2i, type : tile_type) -> bool:
	if (pos.x > 8 || pos.x < 0 || pos.y > 8 || pos.y < 0):
		return false
		
	var index = xy_to_index(pos.x, pos.y)
	
	match type:
		tile_type.GRASS:
			tmap.set_cell(0, pos, 0, Vector2i(0,0))
		tile_type.WATER:
			tmap.set_cell(0, pos, 10, Vector2i(0,0))
		tile_type.TREE:
			if (map[index] == tile_type.GRASS):
				tmap.set_cell(1, pos, 2, Vector2i(1,3))
			else:
				return false
		tile_type.ROCK:
			if (map[index] == tile_type.GRASS):
				tmap.set_cell(1, pos, 2, Vector2i(8,1))
			else:
				return false
				
	map[index] = type
	return true

	
func _ready():
	gen_world()
	place_water()
	place_trees()
	
