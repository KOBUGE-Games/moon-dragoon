extends Node2D

var previous_terrain = 1
var terrain_flat = load("res://terrain/terrain_flat.tscn")
var terrain_bump = load("res://terrain/terrain_bump.tscn")
var terrain_new
var screen_size

#func _ready():
#	set_physics_process(true)
#	pass
#
#func _physics_process(delta):
#	pass

func create_terrain():
	if previous_terrain: # create flat terrain because previous was a bump
		instance_terrain(terrain_flat)
		previous_terrain = 0
	else: # create flat or bump terrain
		previous_terrain = randi() % 2
		if previous_terrain:
			instance_terrain(terrain_bump)
		else:
			instance_terrain(terrain_flat)

func instance_terrain(terrain_type):
	terrain_new = terrain_type.instance()
	terrain_new.set_position(Vector2(global.length*3,global.screen_size.y))
	call_deferred("add_child", terrain_new)
