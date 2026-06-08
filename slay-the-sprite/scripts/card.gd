extends VBoxContainer

@onready var energy_cost: RichTextLabel = $Node/Picture/EnergyCost
@onready var debuff: RichTextLabel = $Node/Text/MarginContainer/Debuff
@onready var node: Control = $Node
## The cursor Sprite
@onready var _focus: Sprite2D = $focus

@onready var card_text: Array = ["Deal %s Damage",
"Gain %s Block"
]

@onready var staff_attack: Sprite2D = $Node/Picture/StaffAttack
@onready var cape_block: Sprite2D = $Node/Picture/CapeBlock

var tween: Tween
var up: bool = false
var og_place: Vector2

## How much does the card cost play
var energy: int
## How much damage it does
var attack: int
## How much block it gives
var block: int

signal update_hands

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	#og_place = position
	print(og_place)
	
	energy = randi_range(0,3)
	energy_cost.text = str(energy)
	
	## Will card be attack of defence
	debuff.text = card_text[randi_range(0,1)]
	
	## Makes card into Attack card
	if debuff.text == card_text[0]:
		staff_attack.show()
		attack += randi_range(1,7)
		debuff.text = debuff.text % attack
		
	## Makes card into Defend card
	elif debuff.text == card_text[1]:
		cape_block.show()
		block += randi_range(1,7)
		debuff.text = debuff.text % block

## Show cursor
func focus():
	_focus.hide()
	_on_mouse_entered()

## Hide cursor
func unfocus():
	_focus.hide()
	_on_mouse_exited()

## Raises the card ready to be played
func _on_mouse_entered() -> void:
	print(self.name)
	self.set_z_index(3)
	if up == false:
		reset_tween()
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position", og_place + Vector2(0, -25), 0.2)
		up = true

## Lowers the card back to hand
func _on_mouse_exited() -> void:
	print(self.name + ":3")
	reset_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", og_place, 0.2)#.set_delay(1)
	self.set_z_index(0)
	up = false
	#update_hands.emit(self)


func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
