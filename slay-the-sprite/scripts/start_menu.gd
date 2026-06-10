extends Control

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Play.pressed.connect(_on_play_pressed)
	%Quit.pressed.connect(_on_quit_pressed)
	
	%Yes.pressed.connect(_on_yes)
	%No.pressed.connect(_on_no)
	
	%ItchButton.pressed.connect(_on_itchIo)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_play_pressed() -> void:
	await tween_animation(%Play)
	$BGM.stop()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	$TextureRect.queue_free()

func _on_quit_pressed() -> void:
	await tween_animation(%Quit)
	$"Really?".show()

func _on_no() -> void:
	await tween_animation(%No)
	$"Really?".hide()
	
func _on_yes() -> void:
	await tween_animation(%Yes)
	get_tree().quit()

## What Itch.Io button does
func _on_itchIo() -> void:
	#%ItchIoLogo.scale = Vector2(0.15, 0.15)
	await tween_animation(%ItchIoLogo)
	#OS.shell_open("https://alchigh.itch.io/slay-the-sprite?secret=aMx2UCYzwXMJyPCpTHn6NEvj53s")
	OS.shell_open("https://alchigh.itch.io/")

## Animates buttons presses
func tween_animation(input):
	print(input.name)
	var input_scale = input.scale
	reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(false)
	tween.tween_property(input, "scale", input_scale * 0.9, 0.05)
	tween.chain().tween_property(input, "scale", input_scale, 0.06)
	await tween.finished

## Kills tween
func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
