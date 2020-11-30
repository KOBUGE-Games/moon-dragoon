extends Node2D


export(PackedScene) var enemy_scene

export var enemy_group = "enemies_top"
export var direction = Vector2(1, 0)
export var speed = 300
export var speed_endgame = 500
var counter = 0
var safe_area = Rect2(-global.screen_size, 3 * global.screen_size)

export(Vector2) var spawn_time_earlygame = Vector2(2.0, 5.0)
export(Vector2) var spawn_time_endgame = Vector2(1.0, 3.0)

# Those are initialized in ready as we use the same script for two
# different scenes, so we shouldn't expect a given scene structure.
var timer : Timer
var slots_state : Array


func get_spawn_time():
	if global.game_over: # Go nuts!
		return rand_range(1.0, 2.0)
	else:
		# Rank up difficulty over time
		var spawn_time = spawn_time_earlygame.linear_interpolate(
					spawn_time_endgame,
					global.get_difficulty_ratio())
		return rand_range(spawn_time.x, spawn_time.y)



func spawn_enemy(slot):
	var enemy = enemy_scene.instance()
	enemy.group = enemy_group
	enemy.slot = slot
	enemy.add_to_group(enemy_group)
	enemy.connect("killed", self, "_on_enemy_killed")
	$slots.get_child(slot).add_child(enemy)
	slots_state[slot] = false

	if global.game_over: # For the lulz.
		enemy.go_nuts()


func _ready():
	# Add timer that will be used to spawn new enemies.
	timer = Timer.new()
	timer.name = "spawn_timer"
	timer.wait_time = get_spawn_time() / 2.0 # Go faster the first round.
	timer.autostart = true
	timer.connect("timeout", self, "_on_spawn_timer_timeout")
	add_child(timer)

	# Keep track of whether each slot is free.
	# True means available, false means filled.
	slots_state = []
	for slot in $slots.get_child_count():
		slots_state.append(true)

	# Debug code to start with all slots filled.
	if false:
		for slot in slots_state.size():
			spawn_enemy(slot)


func _physics_process(delta):
	# Recalculate speed based on time ratio once in a while.
	counter += 1
	if counter > 300:
		counter = 0
		speed = lerp(speed, speed_endgame, global.get_difficulty_ratio())

	# Fix position if we ended up going out of screen by mistake.
	if not safe_area.has_point($slots.global_position):
		if enemy_group == "enemies_top":
			$slots.position.x = (global.screen_size.x - position.x) / 2
		else:
			$slots.position.y = (global.screen_size.y - position.y) / 2

	# We move the whole slots group to move the enemies in sync,
	# but only if there are actual enemies in the group (since they're the ones
	# used to invert direction when hitting bumpers).
	if slots_state.has(false): # False means filled slot.
		$slots.position += direction * speed * delta


func is_slot_in_range(slot):
	var slot_node = $slots.get_child(slot)
	var gpos = slot_node.global_position
	var in_range = false
	if enemy_group == "enemies_top":
		in_range = (gpos.x > position.x + $bumper0.position.x + 100 and
				gpos.x < position.x + $bumper1.position.x - 100)
	else:
		in_range = (gpos.y > position.y + $bumper0.position.y + 100 and
				gpos.y < position.y + $bumper1.position.y - 100)
	return in_range


func restart_timer():
	# Restart with random time.
	timer.wait_time = get_spawn_time()
	timer.start()


func _on_spawn_timer_timeout():
	# Spawn enemy in a free slot, if any. Otherwise restart.
	if not slots_state.has(true): # True means free slot.
		restart_timer()
		return

	# Let's pick a random free slot.
	var free_slots = []
	for i in range(slots_state.size()):
		if slots_state[i] == true: # Free.
			free_slots.append(i)
	free_slots.shuffle()
	for slot in free_slots:
		# Make sure to use a slot within the gameplay area in case the
		# whole slot group has moved far past a bumper (happens with low
		# amount of enemies).
		if not is_slot_in_range(slot):
			continue
		spawn_enemy(slot)
		restart_timer()
		return

	# If we're here, no free slot was in range.
	# Retry in a short time.
	timer.wait_time = 0.5
	timer.start()


func _on_bumper_area_entered(area):
	if area is Enemy:
		direction *= -1.0


func _on_enemy_killed(slot):
	slots_state[slot] = true
