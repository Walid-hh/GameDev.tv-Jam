class_name HealthComponent extends Node2D

var hit_box : HitBox2D
@export var hurt_box : HurtBox2D = null
@export var max_health := 5
var health := max_health :
	set = set_health

func set_health(new_health):
	health = clampi(new_health , 0 , max_health)
	if health == 0:
		get_parent().queue_free()

func damage() :
	#animation_player.call_deferred("play" , "take_damage")
	set_health(health - hit_box.damage)

#func heal():
	#animation_player.play("heal")
	#set_health(health + heal.heal_amount)
