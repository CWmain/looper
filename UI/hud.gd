extends CanvasLayer

@onready var score_label: Label = $ScoreLabel

signal openPauseMenu

func updateScore(newScore: int) -> void:
	score_label.text = "Score: " + str(newScore)


func _on_pause_pressed() -> void:
	openPauseMenu.emit()
