extends CanvasLayer
class_name Fishing

@onready var hook = %hook
@onready var bar = %bar
@onready var last_pressed = Time.get_ticks_msec()
@onready var bar_last_dir_changed = Time.get_ticks_msec()
@onready var progress = %progress

var velocity : float = 0

var bar_vel : float = 0

var points : float = 15
var max_points : float = 50
var count_points : bool = false

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
	
	if (hook.position.x <= 25 && hook.position.x >= -25):
		hook.position += Vector2((velocity*-1),0)
		if (hook.position.x < -25):
			velocity = 0
			hook.position = Vector2(-25, hook.position.y)

	if (hook.position.x >= 25):
		velocity = 0
		hook.position = Vector2(25, hook.position.y)
	else:
		velocity -= .4 * _delta

	#move bar------------------------------------------------

	if (bar.position.x <= 25 && bar.position.x >= -25):
		bar.position = Vector2(fish_path_1(Time.get_ticks_msec()), 0)
		if (bar.position.x < -25):
			bar_vel = 0
			bar.position = Vector2(-25, 0)
		if (bar.position.x > 25):
			bar_vel= 0
			bar.position = Vector2(25, 0)
	
func fish_path_1(x : float) -> float:
	return sin(x/800) * 20



func _on_bar_area_entered(_area):
	count_points = true


func _on_bar_area_exited(_area):
	count_points = false
