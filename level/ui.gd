extends CanvasLayer


onready var live_score : Label = $live_score

const SCORE_TEMPLATE = \
"""Score: %d
Combo: %dx
Enemies killed: %d
"""


func _ready():
	$game_over.hide()
	$info.hide()

	if global.first_run:
		global.first_run = false
		show_info()


func show_info():
	$info.show()
	$info/animation.play("info")
	global.pause(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func hide_info():
	$info.hide()
	$info/animation.stop()
	global.pause(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func _process(_delta):
	live_score.text = SCORE_TEMPLATE % [global.score, global.combo, global.enemies_killed]

	if Input.is_action_just_pressed("ui_cancel") and not $info.is_visible_in_tree():
		show_info()
	elif $info.is_visible_in_tree() and (
			Input.is_action_just_pressed("ui_cancel") or
			Input.is_action_just_pressed("ui_accept")
	):
		hide_info()

	if global.game_over:
		if Input.is_action_just_pressed("ui_accept"):
			$AnimationPlayer.playback_speed = 4.0
		elif Input.is_action_just_released("ui_accept"):
			$AnimationPlayer.playback_speed = 1.0

		if Input.is_action_just_pressed("restart"):
			global.restart()


func game_over():
	$AnimationPlayer.play("game_over")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("highlight_button")


func show_score():
	var score = $game_over/score
	score.clear()
	score.append_bbcode("Score: [b]%d[/b]\n" % global.score)
	yield(get_tree().create_timer(1 / $AnimationPlayer.playback_speed), "timeout")
	score.append_bbcode("Max combo: [b]%dx[/b]\n" % global.highest_combo)
	yield(get_tree().create_timer(1 / $AnimationPlayer.playback_speed), "timeout")
	score.append_bbcode("Enemies killed: [b]%d[/b]\n" % global.enemies_killed)
	yield(get_tree().create_timer(1 / $AnimationPlayer.playback_speed), "timeout")

	var high_scores = $game_over/high_scores
	high_scores.clear()
	high_scores.append_bbcode("[b]High scores:[/b]\n")
	var size = str(global.high_scores[0][0]).length()
	var template = "[code]%" + str(size) + "d[/code]   %s\n"
	for entry in global.high_scores:
		if entry[0] == global.score and entry[1] == "YOU":
			entry = entry.duplicate()
			entry[1] = "[wave amp=50 freq=4][b]YOU[/b][/wave]"
		high_scores.append_bbcode(template % entry)


func _on_restart_pressed():
	global.restart()
