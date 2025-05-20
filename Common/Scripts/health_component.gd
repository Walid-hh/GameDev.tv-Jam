class_name HealthComponent extends Node2D


@export var hurt_box : HurtBox2D = null
@onready var max_health : int = get_parent().max_health
@onready var health := max_health : set = set_health


func set_health(new_health):
	health = clampi(new_health , 0 , max_health)



func damage_health(hit_box : HitBox2D) :
	set_health(health - hit_box.damage)
	print(health)
