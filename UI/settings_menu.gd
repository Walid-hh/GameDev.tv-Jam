extends Control

@onready var settings_button: = %SettingsButton
@onready var menu_button: Button = %MenuButton
@onready var pause_menu: Control = %PauseMenu
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SfxSlider

func _ready() -> void:
	settings_button.pressed.connect(func() -> void :
		visible = true )
	menu_button.pressed.connect(func() -> void :
		visible = false
		pause_menu.visible = true
		)
	music_slider.drag_ended.connect(func(value_changed) -> void :
		if value_changed:
			var music_bus = AudioServer.get_bus_index("Music")
			var value = music_slider.value
			AudioServer.set_bus_volume_db(music_bus , value)
			print(AudioServer.get_bus_volume_db(music_bus))
			)
	sfx_slider.drag_ended.connect(func(value_changed) -> void :
		if value_changed:
			var sfx_bus = AudioServer.get_bus_index("Sfx")
			var value = sfx_slider.value
			AudioServer.set_bus_volume_db(sfx_bus , value)
			)
