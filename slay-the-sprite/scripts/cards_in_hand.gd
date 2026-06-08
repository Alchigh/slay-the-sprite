## How to duplicate https://www.youtube.com/watch?v=-xm2dgHeXmI
## Enemy select: https://www.youtube.com/watch?v=Envh07viSOY
extends Control

const CARD = preload("uid://b80o87kplo5yc")
@onready var end_turn: Button = $"../Background/EndTurn"
@onready var game_manager: Node = $".."

## Energy text
@onready var energy: RichTextLabel = $"../Background/Energy"
@export var max_energy: int
var current_energy: int

## How many cards at the start of turn
@export var hand_size: int 
## How many pixels for hand overlap
@export var card_spacing: int
## Where cards / current hand is stored
var cards: Array = []
var tween: Tween
## To prevent animation bugs
var can_draw: bool = true
## For cursor movent
var index: int = 0

@export var enemies: Control

signal card_played
signal player_attack
signal attack_animation

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_cards()
	end_turn.pressed.connect(empty_hand)
	game_manager.remove_hand.connect(empty_hand)
	current_energy = max_energy
	energy.text = str(current_energy) + "/" + str(max_energy)

## Move "cursor" along the cards
## can_draw checks if draw animation on going on and prevents moving if yes
func _process(_delta: float) -> void:
	if can_draw == false or self.visible == false: 
		return
	
	if Input.is_action_just_pressed("ui_left"):
		if index > 0:
			index -= 1
			switch_focus(index, index+1)
	if Input.is_action_just_pressed("ui_right"):
		if index < cards.size() - 1:
			index += 1
			switch_focus(index, index - 1)
	
	## TODO: Move to Enemy container here?
	## Send int over [0] and have enemien[x].focus() there as well
	## TODO: Enemies should have cursor in their sprites like cards
	## TODO: Remove Block between turns
	## TODO: End turn starts enemy turn > After enemy turn connect to empty hand
	if Input.is_action_just_pressed("attack"):
		
		if cards.size() > 0 and current_energy - cards[index].energy >= 0:
			if cards[index].debuff.text.contains("Gain"):
				card_played.emit(cards[index].block)
			if cards[index].debuff.text.contains("Deal"):
				print("Dealt " + str(cards[index].attack))
				player_attack.emit(cards[index].attack)
				attack_animation.emit(2, false)
				
			current_energy -= cards[index].energy
			print(str(current_energy - cards[index].energy))
			
			energy.text = str(current_energy) + "/" + str(max_energy)
			
			remove_card(cards[index])
		else:
			print("Not enough energy!")
			return

## Moves the cursor along the hand
## Hides and unhides a godot logo
func switch_focus(x,y):
	cards[x].focus()
	cards[y].unfocus()

	#cards[i].og_place += position
	#cards[1].rotation = 12
	## Vibe fan
	#var spacing = 79
	#var width = (cards.size() - 1) * spacing
	#
	#for i in cards.size():
		#var t = float(i) / max(cards.size() - 1, 1)
		#var x_norm = lerp(-1.0, 1.0, t)
		#cards[i].position = Vector2(i * spacing - width / 2,-30 * (1.0 - x_norm * x_norm))
		#cards[i].rotation_degrees = x_norm * 12

## Empties your hand and draws new cards at 
## Connected via pressed signal _ready
## Generates new cards and putts the cursor 
func empty_hand() -> void:
	print(cards.size())
	if can_draw == false: return
	can_draw = false
	
	for i in range(cards.size()):
		reset_tween()
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(cards[i], "position", Vector2(100, 100), .1)
		await tween.finished
		cards[i].queue_free()
	cards.clear()
	draw_cards()
	
	current_energy = max_energy
	energy.text = str(current_energy) + "/" + str(max_energy)

## Generates hand_size amount new cards 
## Connects a custom signal for card Removal
func draw_cards() -> void:
	for i in range(hand_size):
		var card = CARD.instantiate()
		add_child(card)
		cards.append(card)
		card.update_hands.connect(remove_card)
	await update_hand()
	index = 0
	cards[0].focus() ## Waits untill hand drawn before raising a card

## Spreads all the cards into a row
func update_hand() -> void:
	for i in range(cards.size()):
		#cards[i].position = Vector2(i * 60, 0)
		#var place = Vector2(i * 60, 0)
		reset_tween()
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(cards[i], "position", Vector2(i * card_spacing, 0), .1)
		cards[i].og_place = Vector2(i * card_spacing, 0)
		await tween.finished
	
	can_draw = true

## Removes card after it is played. 
func remove_card(card):
	cards.erase(card)
	card.queue_free()
	if cards.is_empty():
		index = 0
		return
	index = 0
	
	update_hand()
	cards[index].focus()
	print(card.name + " played.")

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
