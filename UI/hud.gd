extends CanvasLayer

@onready var score_label: Label = $ScoreLabel

func updateScore(newScore: int) -> void:
	score_label.text = "Score: " + str(newScore)
