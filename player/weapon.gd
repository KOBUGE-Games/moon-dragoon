extends Sprite

export var bullet_speed: int = 450
export(PackedScene) var bullet_scene

onready var animation = $AnimationPlayer

func shoot(direction: Vector2):
	animation.play("shoot")

	var bullet = bullet_scene.instance()
	bullet.direction = direction
	bullet.rotation = direction.angle() - PI / 2
	bullet.position = $exit.global_position
	bullet.speed = bullet_speed
	bullet.friendly = true
	# FIXME: Find a nicer way to access this.
	global.level.add_child(bullet)
