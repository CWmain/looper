extends Control

var play: PackedScene = load("res://Scene/main.tscn")

@onready var crash_explosion: CPUParticles2D = $crashExplosion
@onready var past_portal_explosion: CPUParticles2D = $PastPortalExplosion
@onready var portal_explosion: CPUParticles2D = $PortalExplosion

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var main_menu_decorations: Node2D = $MainMenuDecorations
@onready var options: CanvasLayer = $Options

@onready var portal_background: Sprite2D = $PortalBackground
@export var backgroundRotationSpeed: float = 0.1
func _ready() -> void:
	loadAllParticles()
	MusicController.playMenu()

func _process(delta: float) -> void:
	portal_background.rotate(backgroundRotationSpeed*delta)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play)

func loadAllParticles()->void:
	crash_explosion.emitting = true
	past_portal_explosion.emitting = true
	portal_explosion.emitting = true

func _on_options_pressed() -> void:
	main_menu_buttons.hide()
	main_menu_decorations.hide()
	options.show()

func _on_options_close_option() -> void:
	options.hide()
	main_menu_decorations.show()
	main_menu_buttons.show()
