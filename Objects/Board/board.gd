extends Sprite2D

@export var looper_scene: PackedScene
@export var portal_scene: PackedScene
@export var spawnLocation: Vector2 = Vector2(9,9)
@onready var tick: Timer = $Tick
var tickCount: int = 0

var cell_size: int = 32
var cells: int = 20

var score: int = 0:
	set(value):
		score = value
		scoreChanged.emit(value)
signal scoreChanged(new_score)

var loopers: Array = []

var can_move = false
var game_started = false

var up := Vector2(0, -1)
var down := Vector2(0, 1)
var left := Vector2(-1, 0)
var right := Vector2(1, 0)
var moveDirection: Vector2 

var portal_pos: Vector2
var current_portal: Object
var old_portals: Array
var usedPortalPositions: Array

signal game_over

func _ready() -> void:
	tick.timeout.connect(_on_tick)
	new_game()
	

func new_looper(spawnLoc: Vector2) -> void:
	loopers.append(looper_scene.instantiate())
	add_child(loopers[-1])
	loopers[-1].startingLocation(spawnLoc)
	

func _process(_delta: float) -> void:
	
	if can_move:
		if Input.is_action_just_pressed("Down"):
			if game_started and moveDirection != up:
				print("Up")
				moveDirection = down
			else:
				start_game()
				moveDirection = down
			can_move = false
			
		if Input.is_action_just_pressed("Up"):
			if game_started and moveDirection != down:
				moveDirection = up
			else:
				start_game()
				moveDirection = up
			can_move = false
				
		if Input.is_action_just_pressed("Left"):
			if game_started and moveDirection != right:
				moveDirection = left
			else:
				start_game()
				moveDirection = left
			can_move = false
				
		if Input.is_action_just_pressed("Right"):
			if game_started and moveDirection != left:
				moveDirection = right
			else:
				start_game()
				moveDirection = right
			can_move = false

func _on_tick() -> void:
	#await await_all_tweens()
	tickCount += 1
	can_move = true

	active_looper_movement()
	ghost_looper_movement()
	
	check_out_of_bounds()
	check_portal_collision()
	check_self_collision()

func active_looper_movement() -> void:
	var currentLocation: Vector2 = loopers[-1].get_current_location()
	loopers[-1].moveTo(currentLocation+moveDirection)

func ghost_looper_movement() -> void:
	for looper in loopers:
		looper.play_tick_location(tickCount)

func check_out_of_bounds() -> void:
	var currentPosition = loopers[-1].get_current_location()
	if currentPosition.x < 0 or currentPosition.y < 0 or currentPosition.x >= cells or currentPosition.y >= cells:
		end_game()

# Places the portal in a random unused location
func move_portal() ->void:
	var invalidPlacement = true
	var newPlacement = Vector2(randi_range(0, cells-1), randi_range(0, cells-1))
	while invalidPlacement:
		if newPlacement not in usedPortalPositions:
			invalidPlacement = false
		newPlacement = Vector2(randi_range(0, cells-1), randi_range(0, cells-1))
	usedPortalPositions.append(newPlacement)
	portal_pos = newPlacement
	current_portal.position = gridToReal(newPlacement)
	

func check_portal_collision() -> void:
	var currentPosition = loopers[-1].get_current_location()
	if currentPosition == portal_pos:
		# Increment score
		score += 1
		pause_game()
		# Move portal to new location
		move_portal()
		
		# Reset all loopers to start pos
		for looper in loopers:
			looper.goGray()
			print(looper.locationData[0])
			looper.setLocation(looper.locationData[0])
		
		# Reset tick
		tickCount = 0
		
		# Create and append new looper
		new_looper(loopers[-1].get_current_location())

func check_self_collision() -> void:
	# Nothing to collide with if only looper
	if len(loopers) <= 1:
		return
	
	for i in range(len(loopers)-1):
		var curGhostPosition = loopers[i].get_tick_location(tickCount)
		if loopers[-1].get_current_location() == curGhostPosition:
			end_game()
			break
	

func start_game() -> void:
	game_started = true
	print("Started Timer")
	tick.start()

func pause_game() -> void:
	game_started = false
	tick.stop()

func new_game():
	# Reset all varaiables / arrays
	for looper in loopers:
		looper.queue_free()
	loopers.clear()
	old_portals.clear()
	usedPortalPositions.clear()
	score = 0
	if current_portal != null:
		current_portal.queue_free()
	
	# Recreate portal and Looper
	can_move = true
	portal_pos = Vector2(5, 5)
	current_portal = portal_scene.instantiate()
	add_child(current_portal)
	current_portal.position = gridToReal(portal_pos)
	
	new_looper(spawnLocation)

	game_started = false

func end_game() -> void:
	print("Game ended")
	print("Score: " + str(score))
	tick.stop()
	# Move portal offscreen before reset to avoid a gray portal
	current_portal.position = Vector2(-10, -10)
	game_over.emit()

func gridToReal(gridPos: Vector2) -> Vector2:
	var realPos = (gridPos * cell_size)
	return realPos
