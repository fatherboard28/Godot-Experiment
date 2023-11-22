extends Node2D

@onready var ui = %player_ui

func update_ui_num(val):
	ui.update_score(val)
