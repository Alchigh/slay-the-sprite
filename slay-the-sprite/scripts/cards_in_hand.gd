## How to duplicate https://www.youtube.com/watch?v=-xm2dgHeXmI

extends Control

const CARD = preload("uid://b80o87kplo5yc")
@onready var end_turn: Button = $"../Background/EndTurn"

## How many cards at the start of turn
@export var hand_size: int 
@export var card_spacing: int
## Where cards / current hand is stored
var cards: Array = []
var tween: Tween

var index: int = 0

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_cards()
	end_turn.pressed.connect(empty_hand)
	cards[0].focus()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		if index > 0:
			index -= 1
			switch_focus(index, index+1)
	if Input.is_action_just_pressed("ui_right"):
		if index < cards.size() - 1:
			index += 1
			switch_focus(index, index - 1)
	
	if Input.is_action_just_pressed("attack"):
		if cards.size() > 0:
			remove_card(cards[index])

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
	for i in cards:
		i.queue_free()
	cards.clear()
	draw_cards()
	cards[0].focus()

## Generates hand_size amount new cards 
## Connects a custom signal for card Removal
func draw_cards() -> void:
	for i in range(hand_size):
		var card = CARD.instantiate()
		add_child(card)
		cards.append(card)
		card.update_hands.connect(remove_card)
	update_hand()

## Spreads all the cards into a row
func update_hand() -> void:
	for i in range(cards.size()):
		#cards[i].position = Vector2(i * 60, 0)
		#var place = Vector2(i * 60, 0)
		tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(cards[i], "position", Vector2(i * card_spacing, 0), .2)
		cards[i].og_place = Vector2(i * card_spacing, 0)

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
