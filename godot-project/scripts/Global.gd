extends Node

signal seed_collected(count: int)
signal player_damaged(player_id: int, health: int)
signal weather_changed(weather_type: String)

var player1_score: int = 0
var player2_score: int = 0
var total_seeds: int = 0
var game_active: bool = false
var current_weather: String = "calm"

const WIN_CONDITION_SEEDS: int = 20

func add_score(player_id: int, points: int):
	if player_id == 1:
		player1_score += points
	else:
		player2_score += points

func collect_seed():
	total_seeds += 1
	seed_collected.emit(total_seeds)
	
	if total_seeds >= WIN_CONDITION_SEEDS:
		victory()

func damage_player(player_id: int, damage: int):
	player_damaged.emit(player_id, damage)

func victory():
	game_active = false
	get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")

func defeat():
	game_active = false
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")

func reset_game():
	player1_score = 0
	player2_score = 0
	total_seeds = 0
	game_active = true
	current_weather = "calm"