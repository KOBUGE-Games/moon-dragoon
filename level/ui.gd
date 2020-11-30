extends CanvasLayer


onready var score : Label = $score

const SCORE_TEMPLATE = """
Score: %d
Combo: %dx
"""


func _process(_delta):
	score.text = SCORE_TEMPLATE % [global.score, global.combo]


func _on_player_killed():
	game_over()


func game_over():
	print("Game over!")
	print("Your score is: %d" % global.score)
	print("Your highest reach combo is: %dx" % global.highest_combo)
