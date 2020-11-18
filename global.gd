extends Node

var speed_x = -500
var length = 1024
var screen_size = OS.get_screen_size()

onready var level = $"/root/level1"

func _ready():
	randomize()
