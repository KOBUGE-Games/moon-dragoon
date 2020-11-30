extends Node


var start_time = OS.get_system_time_secs()
var time_passed = 0
var counter = 0
# Ramping up difficulty until this time (s), then constant.
var endgame_time = 180

var game_over = false

var screen_size = OS.get_screen_size()

var score : int = 0
var combo : int = 0
var highest_combo : int = 0
var enemies_killed : int = 0

var music : bool = true

var first_run = true  # Show info.

const HIGH_SCORES_FILE = "user://highscores.cfg"

# Stores as an array of arrays with score and name.
var high_scores = [
	[10000, "Godette"],
	[9001, "Vegeta"],
	[8000, "Juan Alpaca"],
	[6000, "Minilens Mk II"],
	[5000, "Melon Musk"],
]


func _ready():
	# set pause mode to process, keep running when game is paused
	set_pause_mode(PAUSE_MODE_PROCESS)

	randomize()
	load_high_scores()


func _physics_process(_delta):
	# Counter used to avoid calling OS functions too often.
	counter += 1
	if counter > 30:
		counter = 0
		time_passed = OS.get_system_time_secs() - start_time

	# toggle all music and sfx
	if Input.is_action_just_pressed("toggle music") and music:
		AudioServer.set_bus_mute(0,true)
		music = false
	elif Input.is_action_just_pressed("toggle music") and not music:
		AudioServer.set_bus_mute(0,false)
		music = true


func get_difficulty_ratio():
	return min(float(time_passed) / endgame_time, 1.0)


func increase_score(base_score):
	if game_over:
		return
	enemies_killed += 1
	combo += 1
	score += base_score * combo
	if combo > highest_combo:
		highest_combo = combo


func set_game_over():
	game_over = true
	high_scores.append([score, "YOU"])
	high_scores.sort_custom(self, "sort_high_scores")
	high_scores.pop_back()
	save_high_scores()


func sort_high_scores(a, b):
	return a[0] > b[0]


func restart():
	start_time = OS.get_system_time_secs()
	time_passed = 0
	game_over = false
	score = 0
	combo = 0
	highest_combo = 0
	enemies_killed = 0
	get_tree().reload_current_scene()


func load_high_scores():
	var cfg = ConfigFile.new()
	var err = cfg.load(HIGH_SCORES_FILE)
	if err == OK: # Load high scores.
		high_scores = cfg.get_value("highscores", "list", high_scores)
	elif err == ERR_FILE_NOT_FOUND: # Save default high scores.
		cfg.set_value("highscores", "list", high_scores)
		cfg.save(HIGH_SCORES_FILE)
	else:
		print("An error occurred while loading high scores.")


func save_high_scores():
	var cfg = ConfigFile.new()
	cfg.set_value("highscores", "list", high_scores)
	var err = cfg.save(HIGH_SCORES_FILE)
	if err != OK:
		print("An error occurred while saving high scores.")
