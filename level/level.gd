extends Node2D


var previous_terrain = 1
var terrain_flat = preload("res://terrain/terrain_flat.tscn")
var terrain_bump = preload("res://terrain/terrain_bump.tscn")
# Holds reference to last instanced terrain to find its end position.
onready var last_terrain = $terrain/terrain_flat4


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
	var terrain_new = terrain_type.instance()
	terrain_new.set_position(last_terrain.position + Vector2(last_terrain.length, 0))
	$terrain.add_child(terrain_new)
	last_terrain = terrain_new


func _on_player_killed():
	global.game_over = true
	get_tree().call_group("enemies", "go_nuts")
	$ui.game_over()
