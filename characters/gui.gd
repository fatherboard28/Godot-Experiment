extends Control
class_name UI

@onready var wood_label = %number

var wood_num = 0

func update_score(val):
	wood_num += val
	wood_label.text = str(wood_num) 

