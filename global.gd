extends Node


var game_over = false

var screen_size = OS.get_screen_size()

var score : int = 0
var combo : int = 0
var highest_combo : int = 0


func _ready():
	randomize()


func increase_score(base_score):
	if game_over:
		return
	combo += 1
	score += base_score * combo
	if combo > highest_combo:
		highest_combo = combo
