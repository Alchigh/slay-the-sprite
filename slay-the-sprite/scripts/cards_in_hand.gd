extends Control

var cards: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards = get_children()
	for i in cards.size():
		cards[i].position = Vector2(i*60, 4)
		print(cards[i].position)
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
