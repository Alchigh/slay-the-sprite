extends Node

var tween: Tween

func _ready() -> void:
	print("Hello, World!")
	pass


## Animates End Turn button tween
func _on_end_turn_pressed(buttons) -> void:
	var button = get_node(buttons)
	print(".3")
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	tween.tween_property(button, "scale", Vector2(0.9, 0.9), 0.05)
	tween.chain().tween_property(button, "scale", Vector2.ONE, 0.06)


## Animates Settings button tween 
## Reloads and resets Scenes
func _on_settingsbutton_pressed(input) -> void:
	var button = get_node(input)
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	tween.tween_property(button, "scale", Vector2(1.8, 1.8), 0.03)
	tween.chain().tween_property(button, "scale", Vector2(2,2), 0.06).set_delay(0.05)
	await tween.finished
	
	get_tree().reload_current_scene()

## Kills tween
func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
