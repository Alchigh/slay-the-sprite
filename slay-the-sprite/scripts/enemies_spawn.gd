extends Node2D
@onready var game_manager: Node = $"../GameManager"
@onready var player_sprite: AnimatedSprite2D = $"../Player/PlayerSprite"
@onready var hp_Rlabel: RichTextLabel = $"../Player/HP"

const TETRA_ENEMY = preload("uid://byp4j5ltok4fn")
const CUBE_ENEMY = preload("uid://c8yf42n1xaeac")

signal heal
signal enemy_spawn(enemy: Node2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemy(0, "Event1")
	game_manager.next_battle.connect(spawn_enemy)


func spawn_enemy(victories: int, event: String):
	var enemy 
	if event == "Event1" and victories == 0:
		enemy = TETRA_ENEMY.instantiate()

	if event == "Event1" and victories > 0:
		player_sprite.current_hp = min(player_sprite.current_hp + 0.3 * player_sprite.max_hp, player_sprite.max_hp)
		hp_Rlabel.text = str(player_sprite.current_hp) + "/" + str(player_sprite.max_hp)
		enemy = CUBE_ENEMY.instantiate()

	add_child(enemy)
	enemy.hit_player.connect(player_sprite.take_damage)
	enemy.enemy_dead.connect(game_manager.show_events)
	player_sprite.player_block = 0
	player_sprite.add_block(0)
