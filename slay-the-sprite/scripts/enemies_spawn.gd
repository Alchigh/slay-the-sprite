extends Node2D
@onready var game_manager: Node = $"../GameManager"
@onready var player_sprite: AnimatedSprite2D = $"../Player/PlayerSprite"
@onready var hp_Rlabel: RichTextLabel = $"../Player/HP"

const TETRA_ENEMY = preload("uid://byp4j5ltok4fn")
const CUBE_ENEMY = preload("uid://c8yf42n1xaeac")
const REAPER_ENEMY = preload("uid://iy1gbsc3wmbb")

@onready var enemy_type: Array = [TETRA_ENEMY, CUBE_ENEMY, REAPER_ENEMY]
@onready var index: int 

const REAPER_THEME_CHIPTUNE = preload("uid://damugu21evjuw")
const NORMAL_FIGHT = preload("uid://cdeedqu8lknnt")

@onready var bgm_node: AudioStreamPlayer = $"../BGM"

@warning_ignore("unused_signal")
signal heal
@warning_ignore("unused_signal")
signal enemy_spawn(enemy: Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemy(0, 7)
	game_manager.next_battle.connect(event_picker)

## Handles and changes enemy spawn based on button
func event_picker(victories: int, event: String):
	if index == 2 and victories > 2: 
		get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
		return
		
	var hp_cap
	if event == "Event1":
		player_sprite.current_hp = min(player_sprite.current_hp + 0.3 * player_sprite.max_hp, player_sprite.max_hp)
		hp_Rlabel.text = str(player_sprite.current_hp) + "/" + str(player_sprite.max_hp)
		hp_cap = randi_range(12, 20)
	if event == "Event2":
		hp_cap = randi_range(21, 42)
	if event == "Event3":
		hp_cap = randi_range(43, 69)
	spawn_enemy(victories, hp_cap)

## Handles the enemy spawn
func spawn_enemy(victories: int, hp_cap: int):
	var enemy 
	#index = randi_range(min(victories, 2), min(victories, enemy_type.size()-1))
	
	if hp_cap > 4 and victories >= 2:
		index = 2
	else:
		index = randi_range(0, enemy_type.size() - 2)
	
	enemy = enemy_type[index].instantiate()
	enemy.max_hp = hp_cap
	add_child(enemy)
	enemy.hit_player.connect(player_sprite.take_damage)
	enemy.enemy_dead.connect(game_manager.show_events)
	
	player_sprite.player_block = 0
	player_sprite.add_block(0)
	
	if victories > 0 and index < 2:
		change_bgm(NORMAL_FIGHT)
		bgm_node.volume_db = 0

	elif victories > 1 and index >= 2:
		change_bgm(REAPER_THEME_CHIPTUNE)
		bgm_node.volume_db = 8

## Changes the BGM but does not restart the track if it is the same
func change_bgm(track: AudioStream):
	if bgm_node.stream != track:
		bgm_node.stream = track
		bgm_node.play()
