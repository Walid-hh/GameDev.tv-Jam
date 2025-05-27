class_name PlantStates extends MobFSM

class StateAcidRain extends State:
	var attack_scene: PackedScene
	var attack_counter := 0
	var max_attacks := 8
	var attack_timer := 0.0
	var attack_interval := 1.0
	var attack_positions := [Vector2(96, 64), Vector2(160, 64), Vector2(224, 64)]

	func _init(init_mob: Mob, init_attack_scene: PackedScene) -> void:
		super("Acid", init_mob)
		attack_scene = init_attack_scene

	func enter() -> void:
		attack_counter = 0
		attack_timer = 0.0


	func update(delta: float) -> Events:
		attack_timer += delta

		if attack_timer >= attack_interval:
			attack_timer = 0.0
			_spawn_attacks()
			attack_counter += 1

			if attack_counter >= max_attacks:
				return Events.FINISHED

		return Events.NONE

	func _spawn_attacks() -> void:

		for position in attack_positions:
			var attack_instance = attack_scene.instantiate()
			mob.add_sibling(attack_instance)
			attack_instance.global_position = position

	func exit() -> void:

		attack_timer = 0.0
		attack_counter = 0

class StateTrunc extends State :
	
	var attack_scene: PackedScene
	var attack_counter := 0
	var max_attacks := 3
	var attack_timer := 0.0
	var attack_interval := 1.5
	
	func _init(init_mob : Mob , init_attack_scene : PackedScene) -> void:
		super("Trunc" , init_mob)
		attack_scene = init_attack_scene
	
	func enter() -> void:
		attack_counter = 0
		attack_timer = 0.0

	func update(delta: float) -> Events:
			attack_timer += delta

			if attack_timer >= attack_interval:
				attack_timer = 0.0
				var attack_instance := attack_scene.instantiate()
				mob.add_sibling(attack_instance)
				attack_instance.global_position = Vector2(160 , 72)
				attack_counter += 1

				if attack_counter >= max_attacks:
					return Events.FINISHED

			return Events.NONE

	func exit() -> void:
		attack_timer = 0.0
		attack_counter = 0

class StateAcidExplosion extends State :
	
	var attack_scene: PackedScene
	var attack_counter := 0
	var max_attacks := 8
	var attack_timer := 0.0
	var attack_interval := 1
	
	func _init(init_mob : Mob , init_attack_scene : PackedScene) -> void:
		super("AcidExplosion" , init_mob)
		attack_scene = init_attack_scene

	func enter() -> void:
		attack_counter = 0
		attack_timer = 0.0
	
	func update(delta: float) -> Events:
		attack_timer += delta

		if attack_timer >= attack_interval:
			attack_timer = 0.0
			var attack_instance := attack_scene.instantiate()
			mob.add_sibling(attack_instance)
			attack_instance.global_position = Global.player_position
			attack_counter += 1

			if attack_counter >= max_attacks:
				return Events.FINISHED

		return Events.NONE
	
	func exit() -> void:
		attack_timer = 0.0
		attack_counter = 0
