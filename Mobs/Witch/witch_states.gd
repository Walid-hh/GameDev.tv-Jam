class_name WitchStates extends MobFSM


class StateCircularAttack extends State:
	var circular_attack_scene: PackedScene
	var attack_counter: int = 0
	var max_attacks: int = 5
	var initial_delay: float = 0.0
	var attack_interval: float = 1.5
	var timer: float = 0.0
	var waiting_for_initial_delay: bool = true

	func _init(init_mob: Mob, init_circular_attack: PackedScene) -> void:
		super("CircularAttack", init_mob)
		circular_attack_scene = init_circular_attack
		attack_counter = 0

	func enter() -> void:
		timer = 0.0
		waiting_for_initial_delay = true
		attack_counter = 0

	func update(delta: float) -> Events:
		timer += delta
		
		if waiting_for_initial_delay:
			if timer >= initial_delay:
				timer = 0.0
				waiting_for_initial_delay = false
				_spawn_circular_attack()
				attack_counter += 1
				if attack_counter >= max_attacks:
					return Events.FINISHED
		else:
			if timer >= attack_interval:
				timer = 0.0
				_spawn_circular_attack()
				attack_counter += 1

				if attack_counter >= max_attacks:
					return Events.FINISHED
		return Events.NONE

	func _spawn_circular_attack() -> void:
		if circular_attack_scene == null:
			push_error("Circular attack scene is null!")
			return

		var attack = circular_attack_scene.instantiate()

		mob.add_sibling(attack)

		attack.global_position = Global.player_position


	func exit() -> void:
		timer = 0.0
		waiting_for_initial_delay = true

class StateAoeAttack extends State:
	var aoe_attack_scene: PackedScene
	var attack_counter: int = 0
	var max_attacks: int = 8

	var attack_positions: Array[Vector2] = [
	Vector2(64, 64),
	Vector2(128, 64),
	Vector2(192, 64)
	]

	var attack_interval: float = 1.5 
	var timer: float = 0.0

	func _init(init_mob: Mob, init_aoe_attack: PackedScene) -> void:
		super("AoeAttack", init_mob)
		aoe_attack_scene = init_aoe_attack
		attack_counter = 0

	func enter() -> void:
		timer = 0.0
		attack_counter = 0

	func update(delta: float) -> Events:
		timer += delta

		if timer >= attack_interval:
			timer = 0.0
			_spawn_aoe_attack()
			attack_counter += 1

			if attack_counter >= max_attacks:
				return Events.FINISHED

		return Events.NONE

	func _spawn_aoe_attack() -> void:
		if aoe_attack_scene == null:
			push_error("AOE attack scene is null!")
			return

		var position_index = randi() % attack_positions.size()
		var spawn_position = attack_positions[position_index]
		var attack = aoe_attack_scene.instantiate()
		mob.add_sibling(attack)
		attack.global_position = spawn_position
		print("Spawned AOE attack %d of %d at position %s" % [attack_counter + 1, max_attacks, spawn_position])

	func exit() -> void:
		timer = 0.0
