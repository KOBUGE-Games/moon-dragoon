extends Control


var level = preload("res://level/level1.tscn")


func _ready():
	pass


func _input(event):
	if event is InputEventKey and not event.is_echo() and not event.is_pressed(): # Key release.
		set_process_input(false)  # Avoid duplicate calls.
		get_tree().change_scene_to(level)
		# Hack because we don't prevent stuff from starting in the global.
		global.reset()
