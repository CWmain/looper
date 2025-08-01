extends Node

"""
Followed snake tutorial from "Coding with Russ" to create the basic framework 
for looper
https://www.youtube.com/watch?app=desktop&v=DlRP-UBR-2A&ab_channel=CodingWithRuss
"""
@onready var board: Sprite2D = $Board
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	board.scoreChanged.connect(updateScore)
	
func updateScore(value: int) -> void:
	hud.updateScore(value)
