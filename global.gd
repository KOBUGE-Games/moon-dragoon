extends Node


var game_over = false

var screen_size = OS.get_screen_size()

var score : int = 0
var combo : int = 0
var highest_combo : int = 0
var enemies_killed : int = 0


func _ready():
	randomize()


func increase_score(base_score):
	if game_over:
		return
	enemies_killed += 1
	combo += 1
	score += base_score * combo
	if combo > highest_combo:
		highest_combo = combo


func restart():
	game_over = false
	score = 0
	combo = 0
	highest_combo = 0
	enemies_killed = 0
	get_tree().reload_current_scene()
