extends Node

"""
Followed snake tutorial from "Coding with Russ" to create the basic framework 
for looper
https://www.youtube.com/watch?app=desktop&v=DlRP-UBR-2A&ab_channel=CodingWithRuss
"""
# Exports
@export var looper_Scene: PackedScene

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
var old_data: Array
var looper_data: Array
var looper: Array

# Portal Variables
var portal_pos: Vector2
var regen_portal: bool = true

# Movement variables
var start_pos := Vector2(9,9)
var up := Vector2(0, -1)
var down := Vector2(0, 1)
var left := Vector2(-1, 0)
var right := Vector2(1, 0)
var moveDirection: Vector2
var can_move: bool

func _ready() -> void:
	new_game()
	
func new_game()->void:
	score = 0
	moveDirection = up
	can_move = true
	game_started = false
	generate_looper()
	move_portal()
	
func generate_looper() -> void:
	old_data.clear()
	looper_data.clear()
	looper.clear()
	
	looper_data.append(start_pos)
	var curLooper = looper_Scene.instantiate()
	curLooper.position = (start_pos*cell_size) + Vector2(0, cell_size)
	add_child(curLooper)
	looper.append(curLooper)

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


func _on_move_timer_timeout() -> void:
	can_move = true
	
	#TODO: Record the movements until orb is aquired
	# Does the movement
	looper_data[0] += moveDirection
	looper[0].position = (looper_data[0] * cell_size) + Vector2(0, cell_size)
	
	check_out_of_bounds()
	#check_self_collision()
	check_portal_entered()

func check_out_of_bounds() -> void:
	if looper_data[0].x < 0 or looper_data[0].x > cells - 1 or looper_data[0].y < 0 or looper_data[0].y > cells - 1:
		end_game()
	
func end_game() -> void:
	move_timer.stop()
	new_game()

func move_portal() -> void:
	# TODO: Ensure not placed ontop of something else
	# Place randomly
	portal_pos = Vector2(randi_range(0, cells-1), randi_range(0, cells-1))
	print(portal_pos)
	time_portal.position = (portal_pos * cell_size) + Vector2(0, cell_size)
	
func check_portal_entered() -> void:
	if portal_pos == looper_data[0]:
		move_portal()
		score += 1
