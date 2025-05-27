extends Control

@onready var pause_menu: Control = %PauseMenu
@onready var settings_menu: Control = %SettingsMenu


func toggle_visible() -> void:
	visible = !visible
	pause_menu.visible = !pause_menu.visible


func _unhandled_input(event: InputEvent) -> void:
	if settings_menu.visible:
		if event.is_action("ui_cancel"):
			settings_menu.visible = false
			visible = false
			pause_menu.visible = false
	else:
		if event.is_action_pressed("ui_cancel"):
			toggle_visible()
		
func _process(delta: float) -> void:
	if visible:
		get_tree().paused = true
	else :
		get_tree().paused = false
