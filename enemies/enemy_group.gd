extends Node2D


export(PackedScene) var enemy_scene

export var enemy_group = "enemies_top"
export var init_direction = Vector2(1, 0)


func _ready():
	for slot in $slots.get_children():
		var enemy = enemy_scene.instance()
		enemy.add_to_group(enemy_group)
		enemy.direction = init_direction
		slot.add_child(enemy)


func _on_bumper_area_entered(area):
	if area is Enemy:
		get_tree().call_group(enemy_group, "flip_direction")
