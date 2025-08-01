extends CanvasLayer
@onready var retryButton: Button = $VBoxContainer/Retry
@onready var main_menu_button: Button = $VBoxContainer/MainMenu
@onready var options_button: Button = $VBoxContainer/Options

@onready var score_label: Label = $VBoxContainer/ScoreLabel

signal retry
signal main_menu
signal options

func _ready() -> void:
	retryButton.pressed.connect(func():retry.emit())
	main_menu_button.pressed.connect(func():main_menu.emit())
	options_button.pressed.connect(func():options.emit())
	updateDisplayScore(0)

func updateDisplayScore(score: int) -> void:
	score_label.text = "Score: " + str(score)
