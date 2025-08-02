extends Control

var play: PackedScene = load("res://Scene/main.tscn")

@onready var crash_explosion: CPUParticles2D = $crashExplosion
@onready var past_portal_explosion: CPUParticles2D = $PastPortalExplosion
@onready var portal_explosion: CPUParticles2D = $PortalExplosion

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var options: CanvasLayer = $Options

func _ready() -> void:
	loadAllParticles()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(play)

func loadAllParticles()->void:
	crash_explosion.emitting = true
	past_portal_explosion.emitting = true
	portal_explosion.emitting = true

func _on_options_pressed() -> void:
	main_menu_buttons.hide()
	options.show()

func _on_options_close_option() -> void:
	options.hide()
	main_menu_buttons.show()
