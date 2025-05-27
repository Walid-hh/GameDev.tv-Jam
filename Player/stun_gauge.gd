class_name StunGauge extends Node2D

@onready var thunder_bar: ProgressBar = %ThunderBar
var max_value : int = 100
var value : int : set = set_value


func _ready():
	value = 0
	thunder_bar.max_value = 100

func set_value(new_value):
	value = clampi(new_value, 0, max_value)
	thunder_bar.value = value
	if value >= 100 :
		get_parent().thunder_charges += 1
		value = 0

func increase_gauge(new_value):
	set_value(value + new_value)
