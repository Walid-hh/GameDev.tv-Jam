extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(func(body_that_entered) -> void :
		if body_that_entered is Player :
			body_that_entered.crit_attack = true)
	body_exited.connect(func(body_that_exited) -> void :
		if body_that_exited is Player :
			body_that_exited.crit_attack = false)
	Global.mob_staggered.connect(func() -> void :
		set_deferred("monitoring" , true)
		set_deferred("monitorable" , true)
		visible = true)	
	Global.mob_stagger_fininsh.connect(func() -> void :
		set_deferred("monitoring" , false)
		set_deferred("monitorable" , false)
		visible = false
		)
	Global.crit_landed.connect(func() -> void :
		set_deferred("monitoring" , false)
		set_deferred("monitorable" , false)
		visible = false)
