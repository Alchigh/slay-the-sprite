## Notes: 
## How to Tween: https://www.youtube.com/watch?v=KUyQzjpRsU8
## https://www.youtube.com/watch?v=NB64GQX9mrw
## https://godotshaders.com/shader/pixelate/
## https://godotshaders.com/shader/pixelate-into-view-texture-resolution/
## https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html

extends AnimatedSprite2D
@onready var player_big_eyes: AnimatedSprite2D = $"."
@onready var camera_2d: Camera2D = $"../../Camera2D"

var tween: Tween
@export var knockback: int
@export var knockback_speed: float
@export var shake_intensity: int
var og_place: Vector2 = position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Knock effect when space pressed
# Moves object back knocback amount in knockbackspeed and changes the sprite color
func _unhandled_key_input(event: InputEvent) -> void: # _input(event: InputEvent) -> void:
	if event.is_action_pressed("knockback"):
		take_damage()
		print(":3")
	elif event.is_action_pressed("attack"):
		attack_animation()
		print(":4")

func take_damage() -> void:
	reset_tween()
	camera_2d.screen_shake(shake_intensity, knockback_speed)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self, "position", position - Vector2(2 * knockback, 0), knockback_speed)
	tween.tween_property(self, "self_modulate", Color(0.082, 0.082, 0.082, 1.0), knockback_speed)
	tween.chain().tween_property(self, "position", og_place, knockback_speed)
	tween.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), knockback_speed)

func attack_animation() -> void:
	reset_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(knockback, 0), knockback_speed)
	tween.chain().tween_property(self, "position", og_place, knockback_speed)
	camera_2d.screen_shake(shake_intensity, knockback_speed)

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

## Tween animation based on effect
## Moves x amount of pixels positive = to right, negative = left
## Flash means if hit  show hit splash / modulate sprite darker.
#func _unhandled_key_input(event: InputEvent) -> void:
	#if event.is_action_pressed("knockback"):
		#tween_animation(-1, true)
	#elif event.is_action_pressed("attack"):
		#tween_animation(1, false)
#
#
#func tween_animation(direction: int, flash: bool) -> void:
	#reset_tween()
	#camera_2d.screen_shake(4, knockback_speed)
	#tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	#tween.tween_property(self,"position",position + Vector2(knockback * direction, 0),knockback_speed)
#
	#if flash: 
		#tween.tween_property(self,"self_modulate",Color(0.543, 0.543, 0.543),knockback_speed)
#
	#tween.chain().tween_property(self,"position", og_place, knockback_speed)
#
	#if flash:
		#tween.tween_property(self,"self_modulate",Color.WHITE,	knockback_speed)
