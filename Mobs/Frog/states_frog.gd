class_name FrogStates extends MobFSM

class StateSpearThrow extends State:
	var attack_scene: PackedScene
	var attack_counter := 0
	var max_attacks := 5
	var attack_timer := 0.0
	var attack_interval := 1.0

	func _init(init_mob: Mob, init_attack_scene: PackedScene) -> void:
		super("Spear", init_mob)
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

class StateWaterTrap extends State:
	var attack_scene: PackedScene
	var delay := 1.5
	var max_attacks := 5
	var attack_timer := 0.0

	func _init(init_mob: Mob, init_attack_scene: PackedScene) -> void:
		super("Water Trap", init_mob)
		attack_scene = init_attack_scene

	func enter() -> void:
		attack_timer = 0.0


	func update(delta: float) -> Events:
		attack_timer += delta

		if attack_timer >= delay:
			attack_timer = 0.0
			_spawn_attacks()
			return Events.FINISHED

		return Events.NONE

	func _spawn_attacks() -> void:

		for attack_count in max_attacks:
			var attack_instance = attack_scene.instantiate()
			var attack_position := Vector2(randi_range(88 , 232) , randi_range(88 , 160))
			mob.add_sibling(attack_instance)
			attack_instance.global_position = attack_position

	func exit() -> void:

		attack_timer = 0.0

class StateBubbleAttack extends State:
	var attack_scene: PackedScene
	var attack_counter := 0
	var attack_max := 5
	var attack_alive := 4
	var attack_timer := 0.0
	var attack_interval := 1.0
	
	
	func _init(init_mob: Mob, init_attack_scene: PackedScene) -> void:
		super("Bubble Attack", init_mob)
		attack_scene = init_attack_scene

	func enter() -> void:
		attack_timer = 0.0


	func update(delta: float) -> Events:
		attack_timer += delta

		if attack_timer >= attack_interval:
			attack_timer = 0.0
			_spawn_attacks()
			attack_counter += 1

			if attack_counter >= attack_max:
				return Events.FINISHED
				
		return Events.NONE

	func _spawn_attacks() -> void:

		for attack_count in attack_alive:
			var attack_instance = attack_scene.instantiate()
			var attack_position := Vector2(randi_range(88 , 232) , 64)
			mob.add_sibling(attack_instance)
			attack_instance.global_position = attack_position

	func exit() -> void:
		attack_counter = 0.0
		attack_timer = 0.0
