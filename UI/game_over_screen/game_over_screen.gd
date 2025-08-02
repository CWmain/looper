extends CanvasLayer
@onready var retryButton: Button = $VBoxContainer/Retry
@onready var main_menu_button: Button = $VBoxContainer/MainMenu
@onready var options_button: Button = $VBoxContainer/Options

@onready var score_label: Label = $VBoxContainer/ScoreLabel

@onready var options: CanvasLayer = $Options
@onready var buttonContainer: VBoxContainer = $VBoxContainer

signal retry
signal main_menu

func _ready() -> void:
	retryButton.pressed.connect(func():retry.emit())
	main_menu_button.pressed.connect(func():main_menu.emit())
	options_button.pressed.connect(_openOptions)
	options.closeOption.connect(_closeOptions)
	updateDisplayScore(0)

func updateDisplayScore(score: int) -> void:
	score_label.text = "Score: " + str(score)

func _openOptions() -> void:
	print("Option options")
	buttonContainer.hide()
	options.show()
	
func _closeOptions() -> void:
	options.hide()
	buttonContainer.show()
