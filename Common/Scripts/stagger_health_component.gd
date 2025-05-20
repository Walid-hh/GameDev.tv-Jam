class_name StaggerHealthComponent extends Node2D


@export var hurt_box : HurtBox2D = null
@export var stagger_max_health := 5
var stagger_health := stagger_max_health :
	set = set_stagger_health

func set_stagger_health(new_stagger_health):
	stagger_health = clampi(new_stagger_health , 0 , stagger_max_health)

func damage_stagger_health(hit_box : HitBox2D) :
	set_stagger_health(stagger_health - hit_box.damage)
	print(stagger_health)
