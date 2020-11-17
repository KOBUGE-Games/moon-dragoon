extends Sprite

export var bullet_speed: int = 384

onready var muzzle = $muzzle
onready var exit = $exit
onready var animation = $AnimationPlayer

func shoot(collision_mask: int, vector: Vector2):
	animation.play("shoot")
	pass
#	var bullet = preload("res://units/enemies/shared/bullet.tscn").instance()
#	bullet.set_global_position(exit.get_global_position())
#	bullet.target = self.get_global_position() + vector * (1 - sign(self.get_position().x) * self.get_position().length() / vector.length())
#	bullet.speed = bullet_speed
#	bullet.exception = get_parent().get_parent()
#	bullet.set_collision_mask(collision_mask)
#	get_tree().get_root().get_child(0).add_child(bullet)
