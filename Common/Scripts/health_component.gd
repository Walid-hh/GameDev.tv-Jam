class_name HealthComponent extends Node2D
@export var hurt_box : HurtBox2D = null
var max_health : int = 5
var health : int : set = set_health

func _ready():
	max_health = get_parent().max_health
	health = max_health

func set_health(new_health):
	health = clampi(new_health, 0, max_health)
	if get_parent() is Mob:
		if get_parent().health_point_container != null :
			for child in get_parent().health_point_container.get_children():
				child.visible = health > child.get_index()
		if health <= 0 :
			get_parent().state_machine.trigger_event(MobFSM.Events.HEALTH_DEPLETED)

func damage_health(hit_box : HitBox2D):
	set_health(health - hit_box.damage)
