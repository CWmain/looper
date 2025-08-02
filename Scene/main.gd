extends Node

"""
Followed snake tutorial from "Coding with Russ" to create the basic framework 
for looper
https://www.youtube.com/watch?app=desktop&v=DlRP-UBR-2A&ab_channel=CodingWithRuss
"""
@onready var board: Sprite2D = $Board
@onready var hud: CanvasLayer = $HUD
@onready var game_over_screen: CanvasLayer = $GameOverScreen
var main_menu_scene: PackedScene = load("res://Scene/main_menu.tscn")

func _ready() -> void:
	board.scoreChanged.connect(updateScore)
	board.game_over.connect(showGameOverScreen)
	game_over_screen.retry.connect(startNewGame)
	game_over_screen.main_menu.connect(loadMainMenu)
	
func updateScore(value: int) -> void:
	hud.updateScore(value)
	game_over_screen.updateDisplayScore(value)

func showGameOverScreen() -> void:
	game_over_screen.show()

func startNewGame() -> void:
	game_over_screen.hide()
	board.new_game()

func loadMainMenu() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
