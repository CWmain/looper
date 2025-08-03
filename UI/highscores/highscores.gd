extends CanvasLayer

@export var saveFileString: String = "user://scores.txt"

@onready var bottom_5: VBoxContainer = %Bottom5
@onready var top_5: VBoxContainer = %Top5

signal back

func _ready() -> void:
	reloadScores()


func reloadScores() -> void:
	removeListChildren()
	loadScores()

func removeListChildren() -> void:
	for child in bottom_5.get_children():
		child.queue_free()
	for child in top_5.get_children():
		child.queue_free()
	
func loadScores():
	var file = FileAccess.open(saveFileString, FileAccess.READ)
	var stringFile: String
	if (FileAccess.file_exists(saveFileString)):
		file = FileAccess.open(saveFileString, FileAccess.READ)
		stringFile = file.get_as_text()
		file.close()
	
	# Get the highscore list
	var highScores: Array[int]
	if (stringFile.length() > 0):
		highScores = str_to_var(stringFile)
	
	# Re-sort highscore list
	highScores.sort()
	while len(highScores) < 10:
		highScores.insert(0,0)

	# Generate labels and append to list
	for i in range(highScores.size()-1,-1, -1):
		var label: Label = Label.new()
		label.text = str(highScores[i])
		if i < 5:
			top_5.add_child(label)
		else:
			bottom_5.add_child(label)


func _on_back_pressed() -> void:
	back.emit()
