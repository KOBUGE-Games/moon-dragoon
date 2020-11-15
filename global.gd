extends Node

var speed_x = -500
var length = 1024
var screen_size
#var previous_terrain = 1
#var terrain_flat = load("res://terrain/terrain_flat.tscn")
#var terrain_new
func _ready():
	screen_size = OS.get_screen_size()
#func create_terrain():
#	if previous_terrain: # create flat terrain because previous was a bump
#		instance_terrain(terrain_flat)
#		previous_terrain = 0
#	else: # create flat or bump terrain
#		previous_terrain = randi() % 2
#		if previous_terrain:
#			instance_terrain(terrain_flat) # FIXME: change to terrain_bump
#		else:
#			instance_terrain(terrain_flat)
#
#func instance_terrain(terrain_type):
#	terrain_new = terrain_type.instance()
#	terrain_new.set_position(Vector2(length*3,0))
#	add_child(terrain_new)
