extends CanvasLayer
class_name Fishing

@onready var hook = %hook
@onready var bar = %bar
@onready var last_pressed = Time.get_ticks_msec()
@onready var bar_last_dir_changed = Time.get_ticks_msec()
@onready var progress = %progress

var velocity : float = 0

var bar_vel : float = 0

var points : float = 10
var max_points : float = 100
var count_points : bool = false

var bounds : int = 45

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
	

	#move hook------------------------------------------------
	if (Input.is_action_just_pressed("reel") && last_pressed+250 < Time.get_ticks_msec()):
		last_pressed = Time.get_ticks_msec()
		velocity += .5 
	
	if (hook.position.y <= bounds && hook.position.y >= (-1 * bounds)):
		hook.position += Vector2(0,(velocity*-1))
		if (hook.position.y < (-1 * bounds)):
			velocity = 0
			hook.position = Vector2(hook.position.x, (-1 * bounds))

	if (hook.position.y >= bounds):
		velocity = 0
		hook.position = Vector2(hook.position.x, bounds)
	else:
		velocity -= .4 * _delta

	#move bar------------------------------------------------

	if (bar.position.y <= bounds && bar.position.y >= (-1*bounds)):
		bar.position = Vector2(0, fish_path_1(Time.get_ticks_msec()))
		if (bar.position.y < (-1*bounds)):
			bar_vel = 0
			bar.position = Vector2(0, (-1*bounds))
		if (bar.position.y > bounds):
			bar_vel= 0
			bar.position = Vector2(0, bounds)
	
func fish_path_1(x : float) -> float:
	return sin(x/1000) * 40



func _on_bar_area_entered(_area):
	count_points = true


func _on_bar_area_exited(_area):
	count_points = false
