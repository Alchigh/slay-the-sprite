extends Node
@onready var events: HBoxContainer = $Background/NextEvent
@onready var enemy: Node2D = $"../Enemies/Enemy"
@onready var deck: Control = $Deck

var tween: Tween
@onready var victories: int 

signal next_battle
signal remove_hand

func _ready() -> void:
	print("Hello, World!")
	#enemy.enemy_dead.connect(show_events)
	pass

func show_events():
	victories += 1 
	events.show()
	deck.hide()
	
	## TODO: Event 1 = HEAL, 2 = Small mob, 3 = Big mob
	# generate_events

func next_event(input):
	if events.visible == false: return
	await _on_end_turn_pressed(input)
	events.hide()
	var button = get_node(input)
	next_battle.emit(victories, button.name)
	deck.show()
	remove_hand.emit()
	

## Animates End Turn button tween
## TODO: Turn counter text top left?
func _on_end_turn_pressed(buttons) -> void:
	var button = get_node(buttons)
	print(button.name)
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	tween.tween_property(button, "scale", Vector2(0.9, 0.9), 0.05)
	tween.chain().tween_property(button, "scale", Vector2.ONE, 0.06)
	await tween.finished


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
