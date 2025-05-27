extends Control

@onready var exit: Button = %Exit
@onready var resume_button: Button = %ResumeButton
@onready var settings_button: Button = %SettingsButton
@onready var menu_controller: Control = %MenuController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit.pressed.connect(SceneManager.transition_to_scene.bind("res://UI/place_holder.tscn"))
	resume_button.pressed.connect(func() -> void :
		visible = false
		menu_controller.visible = false
		get_tree().paused = false
		)
	settings_button.pressed.connect(func() -> void :
		visible = false
		)
