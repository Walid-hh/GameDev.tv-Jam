class_name HealthComponent extends Node2D


@export var hurt_box : HurtBox2D = null
@export var max_health := 5
var health := max_health :
	set = set_health

func set_health(new_health):
	health = clampi(new_health , 0 , max_health)



func damage(hit_box : HitBox2D) :
	set_health(health - hit_box.damage)
	print(health)
