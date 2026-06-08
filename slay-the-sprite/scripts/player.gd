## Notes: 
## How to Tween: https://www.youtube.com/watch?v=KUyQzjpRsU8
## https://www.youtube.com/watch?v=NB64GQX9mrw
## https://godotshaders.com/shader/pixelate/
## https://godotshaders.com/shader/pixelate-into-view-texture-resolution/
## https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html
## How to add ShortCuts: https://www.youtube.com/watch?v=7Kn5cXcK0MU

extends AnimatedSprite2D
@onready var camera_2d: Camera2D = %Camera2D

var tween: Tween
@export var knockback: int
@export var knockback_speed: float
@export var shake_intensity: int
var og_place: Vector2 = position

@onready var hp_text: RichTextLabel = $"../HP"
@onready var block_text: RichTextLabel = $"../Block"

@export var max_hp: int
var current_hp: int 
@export var player_block: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	block_text.hide()
	block_text.text = str(player_block)
	
	current_hp = max_hp
	hp_text.text = str(max_hp) + "/" + str(max_hp)
	

## Updates block and damage calculation through block
func add_block(amount: int):
	player_block += amount
	
	if player_block >= 0:
		block_text.show()
		block_text.text = str(player_block)
		return 0
	else:
		var dmg = player_block
		player_block = 0
		block_text.hide()
		return dmg

## Updates HP amount and does damage calculation
func take_damage(hit: int) -> void:
	hit = add_block(-1 * hit)
	if hit != 0:
		tween_animation(-2, true)
		current_hp = current_hp + hit
		hp_text.text = "%s/%s" % [current_hp, max_hp]

# Knock effect when space pressed
# Moves object back knocback amount in knockbackspeed and changes the sprite color
func _unhandled_key_input(event: InputEvent) -> void: # _input(event: InputEvent) -> void:
	if event.is_action_pressed("knockback"):
		take_damage(5)
		print(":3")
	elif event.is_action_pressed("attack"):
		tween_animation(1, false)
		print(":4")
		add_block(6)

## Kills tween so no problems
func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

## Tween animation based on effect
## Moves x amount of pixels positive = to right, negative = left
## Hit_Flash means if hit  show hit splash / modulate sprite darker.
func tween_animation(direction: int, hit_flash: bool) -> void:
	reset_tween()
	camera_2d.screen_shake(shake_intensity, knockback_speed)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self,"position",position + Vector2(knockback * direction, 0),knockback_speed)

	if hit_flash: 
		tween.tween_property(self,"self_modulate", Color(0.082, 0.082, 0.082, 1.0),knockback_speed)

	tween.chain().tween_property(self,"position", og_place, knockback_speed)

	if hit_flash:
		tween.tween_property(self,"self_modulate",Color.WHITE,	knockback_speed)
