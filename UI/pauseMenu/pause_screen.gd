extends CanvasLayer

@onready var retryButton: Button = $VBoxContainer/Retry
@onready var main_menu_button: Button = $VBoxContainer/MainMenu
@onready var options_button: Button = $VBoxContainer/Options
@onready var back_button: Button = $VBoxContainer/Back

@onready var options: CanvasLayer = $Options
@onready var buttonContainer: VBoxContainer = $VBoxContainer
@onready var portal_background: Sprite2D = $PortalBackground

signal retry
signal main_menu
signal back

@export var backgroundRotationSpeed: float = 0.1

func _ready() -> void:
	retryButton.pressed.connect(func():retry.emit())
	main_menu_button.pressed.connect(func():main_menu.emit())
	options_button.pressed.connect(_openOptions)
	options.closeOption.connect(_closeOptions)
	back_button.pressed.connect(func():back.emit())

func _process(delta: float) -> void:
	portal_background.rotate(backgroundRotationSpeed*delta)

func _openOptions() -> void:
	buttonContainer.hide()
	options.reloadSliders()
	options.show()
	
func _closeOptions() -> void:
	options.hide()
	buttonContainer.show()
