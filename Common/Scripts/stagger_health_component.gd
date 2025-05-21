class_name StaggerHealthComponent extends Node2D

@export var hurt_box : HurtBox2D = null
var stagger_max_health : int = 5
var stagger_health : int : set = set_stagger_health

func _ready() -> void:
	stagger_max_health = get_parent().max_stagger_health
	stagger_health = stagger_max_health

func set_stagger_health(new_stagger_health):
	stagger_health = clampi(new_stagger_health , 0 , stagger_max_health)
	if stagger_health <= 0 :
		get_parent().state_machine.trigger_event(MobFSM.Events.STAGGER_HEALTH_DEPLETED)

func damage_stagger_health(hit_box : HitBox2D) :
	set_stagger_health(stagger_health - hit_box.damage)
