extends CanvasLayer
class_name Fishing

@onready var fish = %fish
@onready var bar = %bar
@onready var last_pressed = Time.get_ticks_msec()
@onready var bar_last_dir_changed = Time.get_ticks_msec()
@onready var progress = %progress

var velocity : float = 0

var fish_vel : float = 0

var points : float = 10
var max_points : float = 100
var count_points : bool = false

var bounds : int = 24

var win : bool = false
var lose : bool = false

func _process(_delta):
	if (count_points):
		points += 10 * _delta
	else:
		points -= 5 * _delta

	var ratio = points/max_points
	if (ratio >= 1):
		win = true
	elif (ratio <= 0):
		lose = true
	else:
		progress.scale = Vector2(1,ratio)
	

	#move bar------------------------------------------------
	if (Input.is_action_just_pressed("reel") && last_pressed+250 < Time.get_ticks_msec()):
		last_pressed = Time.get_ticks_msec()
		velocity += .2 
	
	if (bar.position.y <= bounds && bar.position.y >= (-1 * bounds)):
		bar.position += Vector2(0,(velocity*-1))
		if (bar.position.y < (-1 * bounds)):
			velocity = 0
			bar.position = Vector2(bar.position.x, (-1 * bounds))

	if (bar.position.y >= bounds):
		velocity = 0
		bar.position = Vector2(bar.position.x, bounds)
	else:
		velocity -= .1 * _delta

	#move fish------------------------------------------------
	if (fish.position.y <= bounds && fish.position.y >= (-1*bounds)):
		fish.position = Vector2(0, fish_path_1(Time.get_ticks_msec()))
		if (fish.position.y < (-1*bounds)):
			fish_vel = 0
			fish.position = Vector2(0, (-1*bounds))
		if (fish.position.y > bounds):
			fish_vel= 0
			fish.position = Vector2(0, bounds)
	
func fish_path_1(x : float) -> float:
	return sin(x/1000) * 20



func _on_bar_area_entered(_area):
	count_points = true


func _on_bar_area_exited(_area):
	count_points = false
