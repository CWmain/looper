extends Node2D
class_name Looper

@export var tweenTime: float = 0.5


var isCurrent: bool = true
# Location data will be stored as grid coordinates
var locationData: Array[Vector2]
var currentTween: Tween

func startingLocation(loc: Vector2) -> void:
	print("Adding start location")
	locationData.append(loc)
	var board = get_parent()
	if board == null:
		printerr("NO PARENT WILL NOT WORK")
		return
	position = board.gridToReal(loc)
	
# Called when is the active Looper, cause player to move to new 
# location and append locationData
func moveTo(newLocation: Vector2) -> void:
	# Ensure any previous movement is completed before moving
	kill_active_tween()

	var board = get_parent()
	if board == null:
		printerr("NO PARENT WILL NOT WORK")
		return
	locationData.append(newLocation)
	currentTween = create_tween()
	currentTween.tween_property(self, "position", board.gridToReal(newLocation), tweenTime)

# Set an abritary location for the looper (no tween animation)
func setLocation(newLocation: Vector2) -> void:
	# Ensure any previous movement is completed before moving
	kill_active_tween()

	var board = get_parent()
	if board == null:
		printerr("NO PARENT WILL NOT WORK")
		return
	
	position = board.gridToReal(newLocation)

# Assumed they have been correctly reset to the start
func play_tick_location(tick: int) -> void:
	var toCheck: int = tick if tick < len(locationData) else len(locationData)-1
	
	# Ensure any previous movement is completed before moving
	kill_active_tween()

	var board = get_parent()
	if board == null:
		printerr("NO PARENT WILL NOT WORK")
		return
	currentTween = create_tween()
	currentTween.tween_property(self, "position", board.gridToReal(locationData[toCheck]), tweenTime)

func get_tick_location(tick: int):
	var toCheck: int = tick if tick < len(locationData) else len(locationData)-1
	return locationData[toCheck]

func get_current_location() -> Vector2:
	return locationData[-1]

func goGray() -> void:
	self.self_modulate = Color.DARK_GRAY

# Waits for the tween to finish, than kills it
func kill_active_tween() -> void:
	if currentTween != null and currentTween.is_running():
		currentTween.kill()
