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


func _process(_delta):
	live_score.text = SCORE_TEMPLATE % [global.score, global.combo, global.enemies_killed]

	if Input.is_action_just_pressed("ui_cancel") and not $info.is_visible_in_tree():
		$info.show()
		$AnimationPlayer.play("info")
		get_tree().set_pause(true)
	elif Input.is_action_just_pressed("ui_cancel") and $info.is_visible_in_tree():
		$info.hide()
		get_tree().set_pause(false)
		$AnimationPlayer.stop()

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
	score.push_align(RichTextLabel.ALIGN_CENTER)
	score.append_bbcode("Score: [b]%d[/b]\n" % global.score)
	yield(get_tree().create_timer(1 / $AnimationPlayer.playback_speed), "timeout")
	score.append_bbcode("Max combo: [b]%dx[/b]\n" % global.highest_combo)
	yield(get_tree().create_timer(1 / $AnimationPlayer.playback_speed), "timeout")
	score.append_bbcode("Enemies killed: [b]%d[/b]\n" % global.enemies_killed)


func _on_restart_pressed():
	global.restart()
