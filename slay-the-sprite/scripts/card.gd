extends VBoxContainer

@onready var energy_cost: RichTextLabel = $Node/Picture/EnergyCost
@onready var debuff: RichTextLabel = $Node/Text/MarginContainer/Debuff
@onready var node: Control = $Node

@onready var card_text: Array = ["Deal %s Damage" % randi_range(1,7),
"Gain %s Block" % randi_range(1,7)
]

@onready var staff_attack: Sprite2D = $Node/Picture/CapeBlock
@onready var cape_block: Sprite2D = $Node/Picture/CapeBlock

var tween: Tween
var up: bool = false
var og_place: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	og_place = position
	print(og_place)
	
	energy_cost.text = str(randi_range(0,3))
	debuff.text = card_text[randi_range(0,1)]
	
	if debuff.text == card_text[0]:
		staff_attack.show()
	elif debuff.text == card_text[1]:
		cape_block.show()

func _on_mouse_entered() -> void:
	print(self.name)
	self.set_z_index(3)
	if up == false:
		reset_tween()
		tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(node, "position", og_place + Vector2(0, -100), 0.5)
		up = true

func _on_mouse_exited() -> void:
	print(self.name + ":3")
	reset_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node, "position", og_place, 0.5)#.set_delay(1)
	self.set_z_index(0)
	up = false

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
