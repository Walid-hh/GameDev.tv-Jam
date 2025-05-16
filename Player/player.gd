class_name Player extends CharacterBody2D

@onready var player_sprite: Sprite2D = %PlayerSprite
@export_category("Base Stats")
@export var walk_speed := 100

func _ready() -> void:
	var state_machine := PlayerFSM.StateMachine.new()
	add_child(state_machine)
	
	var move_world := PlayerFSM.StateMoveinWorld.new(self)
	move_world.speed = walk_speed
	
	state_machine.activate(move_world)
