extends Node2D

@onready var hp_Rlabel: RichTextLabel = $HP
@onready var block_Rlabel: RichTextLabel = $BlockEnemy
@onready var tween_animation: Node = $TweenAnimation

## For connecting card effects to enemy
@onready var deck: Control = $"../../GameManager/Deck"
## For starting enemy turn
@onready var end_turn: Button = $"../../GameManager/Background/EndTurn"

## Max HP of the enemy
@export var max_hp: int
## Current HP of the enemy
var current_hp: int
## How much block does the enemy have
var block_amount: int
@export var block: int
## Enemy DMG
@export var attack: int


## AI moves for randomization
@onready var enemy_moves: Array = ["smallhit", "normalHit", "bigHit", "defend"]
@onready var small_attack: Sprite2D = $actionSprites/smallAttack
@onready var medium_attack: Sprite2D = $actionSprites/mediumAttack
@onready var big_attack: Sprite2D = $actionSprites/bigAttack
@onready var defend: Sprite2D = $actionSprites/defend

@onready var next_move: int
## Is it Enemies turn
var enemy_turn: bool = false

signal hit_player
signal enemy_dead

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = max_hp
	hp_manager(0)
	block_manager(block)
	enemy_AI()
	enemy_turn = true
	deck.player_attack.connect(hp_manager)
	end_turn.pressed.connect(enemy_AI)

## Manages Enemy HP
func hp_manager(hit: int):
	hit = block_manager(-1 * hit)
	if hit != 0:
		tween_animation.tween_animation(2, true)
		current_hp = current_hp + hit
	if current_hp < 1: 
		enemy_dead.emit()
		self.queue_free()
	
	hp_Rlabel.text = "%s/%s" % [current_hp, max_hp]

## Manages Enemy Block
func block_manager(amount: int):
	block_amount += amount
	
	if block_amount > 0:
		block_Rlabel.show()
		block_Rlabel.text = str(block_amount)
		return 0
	else:
		var dmg = block_amount
		block_amount = 0
		block_Rlabel.hide()
		return dmg

## Semi random does the enemy attack or defend
func enemy_AI():
	if enemy_turn:
		match  next_move:
			0: 
				tween_animation.tween_animation(-1, false)
				hit_player.emit(attack * 0.3)
				small_attack.hide()
			1: 
				tween_animation.tween_animation(-1, false)
				hit_player.emit(attack * 1)
				medium_attack.hide()
			2: 
				tween_animation.tween_animation(-1, false)
				hit_player.emit(attack * 1.3)
				big_attack.hide()
			3: 
				block_manager(randi_range(3, 7))
				defend.hide()
		
	next_move = randf_range(0, enemy_moves.size())
	match next_move:
		0: small_attack.show()
		1: medium_attack.show()
		2: big_attack.show()
		3: defend.show()
			
	print(enemy_moves[next_move])
