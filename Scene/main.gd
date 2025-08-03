extends Node

"""
Followed snake tutorial from "Coding with Russ" to create the basic framework 
for looper
https://www.youtube.com/watch?app=desktop&v=DlRP-UBR-2A&ab_channel=CodingWithRuss
"""
@onready var board: Sprite2D = $Board
@onready var hud: CanvasLayer = $HUD
@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var pause_screen: CanvasLayer = $pause_screen
var main_menu_scene: PackedScene = load("res://Scene/main_menu.tscn")

func _ready() -> void:
	board.scoreChanged.connect(updateScore)
	board.game_over.connect(showGameOverScreen)
	game_over_screen.retry.connect(startNewGame)
	game_over_screen.main_menu.connect(loadMainMenu)
	hud.openPauseMenu.connect(_pauseGame)
	pause_screen.back.connect(_resumeGame)
	pause_screen.retry.connect(startNewGame)
	pause_screen.main_menu.connect(loadMainMenu)
	
	MusicController.playGame()
	
func updateScore(value: int) -> void:
	hud.updateScore(value)
	game_over_screen.updateDisplayScore(value)

func showGameOverScreen() -> void:
	MusicController.pauseMusic()
	game_over_screen.show()

func startNewGame() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func loadMainMenu() -> void:
	get_tree().paused = false
	MusicController.pauseMusic()
	get_tree().change_scene_to_packed(main_menu_scene)

func _pauseGame() -> void:
	pause_screen.show()
	MusicController.pauseMusic()
	get_tree().paused = true

func _resumeGame() -> void:
	pause_screen.hide()
	MusicController.playGame()
	get_tree().paused = false
