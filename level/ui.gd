extends CanvasLayer


onready var live_score : Label = $live_score

const SCORE_TEMPLATE = \
"""Score: %d
Combo: %dx
Enemies killed: %d
"""


func _ready():
	$game_over.hide()


func _process(_delta):
	live_score.text = SCORE_TEMPLATE % [global.score, global.combo, global.enemies_killed]


func game_over():
	$AnimationPlayer.play("game_over")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("highlight_button")


func show_score():
	var score = $game_over/score
	score.push_align(RichTextLabel.ALIGN_CENTER)
	score.append_bbcode("Score: [b]%d[/b]\n" % global.score)
	yield(get_tree().create_timer(1.0), "timeout")
	score.append_bbcode("Max combo: [b]%dx[/b]\n" % global.highest_combo)
	yield(get_tree().create_timer(1.0), "timeout")
	score.append_bbcode("Enemies killed: [b]%d[/b]\n" % global.enemies_killed)


func _on_restart_pressed():
	global.restart()
