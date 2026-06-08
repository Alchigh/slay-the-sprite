extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _gui_input(event):
	if event is InputEventKey and event.button_index == KEY_Y and event.pressed:
		print("Left mouse button was pressed!")
