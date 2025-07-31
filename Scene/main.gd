extends Node

"""
Followed snake tutorial from "Coding with Russ" to create the basic framework 
for looper
https://www.youtube.com/watch?app=desktop&v=DlRP-UBR-2A&ab_channel=CodingWithRuss
"""
# Exports
@export var looper_Scene: PackedScene
@export var portalImage: PackedScene

# Onready
@onready var hud: CanvasLayer = $HUD
@onready var move_timer: Timer = $MoveTimer
@onready var time_portal: AnimatedSprite2D = $TimePortal

# game variables
var score: int = 0:
	set(value):
		score = value
		hud.updateScore(value)
var game_started: bool = false

var cells: int = 20
var cell_size: int = 50

# looper variables
var looper_tween: Array
var looper_data: Array
var looper: Array
# TODO: This doesn't need to be a variable (can simply use -1 as current looper is always last)
var controlledLooperIndex = -1

# Portal Variables
var portal_pos: Vector2
var pastPortals: Array
var regen_portal: bool = true

# Movement variables
var start_pos := Vector2(9,9)
var up := Vector2(0, -1)
var down := Vector2(0, 1)
var left := Vector2(-1, 0)
var right := Vector2(1, 0)
var moveDirection: Vector2
var can_move: bool

var tick = -1

func _ready() -> void:
	new_game()
	
func new_game()->void:
	score = 0
	controlledLooperIndex = -1
	tick = -1
	moveDirection = up
	can_move = true
	game_started = false
	
	for portal in pastPortals:
		portal.free()
	pastPortals.clear()
	generate_looper()
	move_portal()
	
func generate_looper() -> void:
	for l in looper:
		l.free()
	looper_tween.clear()
	looper_data.clear()
	looper.clear()
	
	newLooper(start_pos)

func _process(_delta: float) -> void:
	if can_move:
		if Input.is_action_just_pressed("Down") and moveDirection != up:
			moveDirection = down
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("Up") and moveDirection != down:
			moveDirection = up
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("Left") and moveDirection != right:
			moveDirection = left
			can_move = false
			if not game_started:
				start_game()
		if Input.is_action_just_pressed("Right") and moveDirection != left:
			moveDirection = right
			can_move = false
			if not game_started:
				start_game()

func start_game() -> void:
	game_started = true
	print("Started Timer")
	move_timer.start()

func pause_game() -> void:
	game_started = false
	move_timer.stop()

func _on_move_timer_timeout() -> void:
	can_move = true
	
	#TODO: Record the movements until orb is aquired
	tick += 1
	
	for i in range(controlledLooperIndex):
		if tick < len(looper_data[i]):
			looper[i].position = (looper_data[i][tick] * cell_size) + Vector2(0, cell_size)
	
	looper_data[controlledLooperIndex].append(looper_data[controlledLooperIndex][-1]+moveDirection) 
	#TODO: Tween causes issues when resetting board will solve later
	#looper_tween[controlledLooperIndex] = create_tween()
	#looper_tween[controlledLooperIndex].tween_property(looper[controlledLooperIndex], "position", (looper_data[controlledLooperIndex][-1] * cell_size) + Vector2(0, cell_size), move_timer.wait_time)
	looper[controlledLooperIndex].position = (looper_data[controlledLooperIndex][-1] * cell_size) + Vector2(0, cell_size)
	
	check_out_of_bounds()
	check_self_collision()
	check_portal_entered()
	

func check_self_collision() -> void:
	# Check if any colisions occur between the current looper and all previous loopers
	for i in range(len(looper_data)):
		if i == controlledLooperIndex:
			continue
		var allPositions = looper_data[i]
		var checkIndex = tick if tick < len(allPositions) else len(allPositions)-1
		if allPositions[checkIndex] == looper_data[controlledLooperIndex][tick]:
			end_game()
			break

func check_out_of_bounds() -> void:
	if looper_data[controlledLooperIndex][-1].x < 0 or looper_data[controlledLooperIndex][-1].x > cells - 1 or looper_data[controlledLooperIndex][-1].y < 0 or looper_data[controlledLooperIndex][-1].y > cells - 1:
		end_game()
	
func end_game() -> void:
	print("Game ended")
	print("Score: " + str(score))
	move_timer.stop()
	# Move portal offscreen before reset to avoid a gray portal
	time_portal.position = Vector2(-10, -10)
	new_game()

func move_portal() -> void:
	# TODO: Ensure not placed ontop of something else
	# Place randomly
	var pastPortal = portalImage.instantiate()
	pastPortal.self_modulate = Color.DARK_SLATE_GRAY
	pastPortal.position = time_portal.position
	add_child(pastPortal)
	pastPortals.append(pastPortal)
	portal_pos = Vector2(randi_range(0, cells-1), randi_range(0, cells-1))
	time_portal.position = (portal_pos * cell_size) + Vector2(0, cell_size)
	
func check_portal_entered() -> void:
	if portal_pos == looper_data[controlledLooperIndex][-1]:
		# Reset all loopers to starting position
		for i in range(0, len(looper)):
			looper[i].position = (looper_data[i][0] * cell_size) + Vector2(0, cell_size)
		
		# Create a new looper at portal collision location
		newLooper(portal_pos)
		move_portal()
		pause_game()
		tick = -1
		score += 1

func newLooper(spawnLocation: Vector2) -> void:
	# Gray out old looper if not first looper
	if controlledLooperIndex >= 0:
		looper[controlledLooperIndex].self_modulate = Color.DARK_SLATE_GRAY
	
	controlledLooperIndex += 1
	#looper_tween.append(Tween)
	looper_data.append([])
	looper_data[controlledLooperIndex].append(spawnLocation)
	var curLooper = looper_Scene.instantiate()
	curLooper.position = (spawnLocation*cell_size) + Vector2(0, cell_size)
	add_child(curLooper)
	looper.append(curLooper)
