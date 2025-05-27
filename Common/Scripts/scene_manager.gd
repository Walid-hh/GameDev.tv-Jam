# SceneManager.gd
# Add this as an AutoLoad singleton in Project Settings
extends Node

var current_scene = null
var transition_overlay: ColorRect
var fade_duration: float = 0.5

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# Create fade overlay
	transition_overlay = ColorRect.new()
	transition_overlay.color = Color.BLACK
	transition_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	transition_overlay.modulate.a = 0.0
	transition_overlay.z_index = 1000
	get_tree().root.add_child.call_deferred(transition_overlay)

func transition_to_packed_scene(packed_scene: PackedScene) -> void:
	# Fade out
	var tween = create_tween()
	tween.tween_property(transition_overlay, "modulate:a", 1.0, fade_duration * 0.5)
	await tween.finished
	
	# Change scene
	current_scene.free()
	current_scene = packed_scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
	# Fade in
	tween = create_tween()
	tween.tween_property(transition_overlay, "modulate:a", 0.0, fade_duration * 0.5)
	await tween.finished
	

func transition_to_scene(scene_path: String) -> void:
	var packed_scene = load(scene_path)
	await transition_to_packed_scene(packed_scene)
