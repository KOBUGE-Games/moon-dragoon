extends CanvasLayer


onready var live_score : Label = $live_score

const SCORE_TEMPLATE = \
"""Score: %d
Combo: %dx
Enemies killed: %d
"""

const RANDOM_BITS = [
	"[code]ALL YOUR BASE ARE BELONG TO US.[/code] (meow)",
	"Alas, your enlightenment was brief and you shall never make the Planar Earth Selenian Territories' discovery public.",
	"*crrr* *kssh* [code]TAKE OFF EVERY 'ZIG'!![/code]\n*gshht* [code]YOU KNOW WHAT YOU DOING.[/code] *clang*",
	"As you are blown to pieces, you turn towards the distant [color=aqua]Blue Disc[/color] and mutter ̈́“For great justice...”",
	"[b][fade start=5 length=5]Rosebud...[/fade][/b]",
	"[color=aqua]Blue[/color]... NO! [color=yellow][b][fade start=3 length=14]Yellooooooooow...[/fade][/b][/color]",
	"[shake rate=10 level=20]THE END.[/shake]",
]

func _ready():
	$game_over.hide()

	if global.first_run:
		global.first_run = false
		show_info()
	else:
		hide_info()

	$game_over/random_bit.set_bbcode(RANDOM_BITS[randi() % RANDOM_BITS.size()])


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
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
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
