extends CanvasLayer

@onready var master: HSlider = $VBoxContainer/HBoxContainer/VBoxContainer/Master
@onready var sfx: HSlider = $VBoxContainer/HBoxContainer/VBoxContainer/SFX
@onready var music: HSlider = $VBoxContainer/HBoxContainer/VBoxContainer/Music

signal closeOption

func _ready() -> void:
	print(db_to_linear(AudioServer.get_bus_volume_db(0)))
	master.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	sfx.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	music.value = db_to_linear(AudioServer.get_bus_volume_db(2))


func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_back_pressed() -> void:
	closeOption.emit()
