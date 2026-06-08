extends Node

@onready var sprite: AnimatedSprite2D = $"../Sprite"
@onready var camera_2d: Camera2D = $"../../../Camera2D"


var tween: Tween
@export var knockback: int
@export var knockback_speed: float
@export var shake_intensity: int
var og_place: Vector2

func _ready() -> void:
	og_place = sprite.position

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
	tween.tween_property(sprite,"position", sprite.position + Vector2(knockback * direction, 0),knockback_speed)

	if hit_flash: 
		tween.tween_property(sprite,"self_modulate", Color(0.082, 0.082, 0.082, 1.0),knockback_speed)

	tween.chain().tween_property(sprite,"position", og_place, knockback_speed)

	if hit_flash:
		tween.tween_property(sprite,"self_modulate",Color.WHITE,	knockback_speed)
