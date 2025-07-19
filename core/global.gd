extends Node

var score: int = 0
var lives: int = 3

var player_health: int = 3
var player_max_health: int = 3

var unlocked_abilities: Dictionary = {
	"wall_jump": true,
	"dash": false,
	"double_jump": false
}

signal score_changed(new_score)
signal health_changed(new_health)
signal lives_changed(new_lives)
signal player_died
signal ability_unlocked(ability_name)

func damage_player(amount: int):
	player_health = max(0, player_health - amount)
	health_changed.emit(player_health)
	
	if player_health == 0:
		player_died.emit()

func lose_life():
	lives -= 1
	lives_changed.emit(lives)

func add_score(amount: int):
	score += amount
	score_changed.emit(score)

func grant_ability(ability_name: String):
	if not unlocked_abilities.has(ability_name) or unlocked_abilities[ability_name] == true:
		return
	
	unlocked_abilities[ability_name] = true
	ability_unlocked.emit(ability_name)

func reset_level_state():
	player_health = player_max_health
	health_changed.emit(player_health)
	score = 0
	score_changed.emit(score)
