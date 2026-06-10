extends Node2D

@onready var hp_Rlabel: RichTextLabel = $HP
@onready var block_Rlabel: RichTextLabel = $BlockEnemy
@onready var dmg_Rlabel: RichTextLabel = $DMG
@onready var tween_animation: Node = $TweenAnimation
## SFX 
@onready var got_hit: AudioStreamPlayer = $GotHit
@onready var dead_sfx: AudioStreamPlayer = $DeadSFX
@onready var shield_gain: AudioStreamPlayer = $ShieldGain
@onready var block_hit: AudioStreamPlayer = $BlockHit

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
		current_hp = max(current_hp + hit, 0)
		got_hit.play()
		
	hp_Rlabel.text = "%s/%s" % [current_hp, max_hp]
	await got_hit.finished
	
	if current_hp < 1: 
		dead_sfx.play()
		await dead_sfx.finished
		enemy_dead.emit()
		self.queue_free()
		


## Manages Enemy Block
func block_manager(amount: int):
	block_amount += amount
	var dmg
	
	if block_amount >= 0 and amount != 0:
		block_Rlabel.show()
		block_Rlabel.text = str(block_amount)
		block_hit.play()
		dmg = 0
	else:
		dmg = block_amount
		block_amount = 0
	
	if block_amount == 0: block_Rlabel.hide()
	
	return dmg

## Semi random does the enemy attack or defend
func enemy_AI():
	if enemy_turn:
		match  next_move:
			0: 
				tween_animation.tween_animation(-1, false)
				hit_player.emit(attack * 0.3 + 1)
				small_attack.hide()
			1: 
				tween_animation.tween_animation(-1, false)
				hit_player.emit(attack * 1 + 1)
				medium_attack.hide()
			2: 
				tween_animation.tween_animation(-1, false)
				hit_player.emit(attack * 1.3 + 1)
				big_attack.hide()
			3: 
				block_manager(randi_range(3, 7))
				shield_gain.play()
				defend.hide()
		
	next_move = randi_range(0, enemy_moves.size() - 1)
	match next_move:
		0: 
			small_attack.show()				
			dmg_Rlabel.show()
			dmg_Rlabel.text = str(roundi(attack * 0.3 + 1))
		1: 
			medium_attack.show()
			dmg_Rlabel.show()
			dmg_Rlabel.text = str(roundi(attack * 1 + 1))
		
		2: 
			big_attack.show()
			dmg_Rlabel.show()
			dmg_Rlabel.text = str(roundi(attack * 1.3 + 1))
		
		3: 
			defend.show()
			dmg_Rlabel.hide()
			
	print(enemy_moves[next_move])
