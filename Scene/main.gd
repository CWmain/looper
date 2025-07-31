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

# game variables
var score: int = 0:
	set(value):
		score = value
		hud.updateScore(value)
var game_started: bool = false
var cell_size: int = 50
# looper variables
var old_data: Array
var looper_data: Array
var looper: Array

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
	score = 1
	moveDirection = up
	can_move = true
	generate_looper()
	
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
	move_timer.start()


func _on_move_timer_timeout() -> void:
	can_move = true
	
	looper_data[0] += moveDirection
	looper[0].position = (looper_data[0] * cell_size) + Vector2(0, cell_size)
