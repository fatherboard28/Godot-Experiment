extends Camera2D

@onready var player = %player

func _physics_process(_delta):
	position_smoothing_enabled = true
	position = player.position
