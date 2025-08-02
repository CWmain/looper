extends Node2D
class_name Looper

@export var tweenTime: float = 0.5

@onready var sprite: Sprite2D = $Sprite2D
@onready var past_portal_sound: AudioStreamPlayer = $PastPortalSound

@onready var past_portal_explosion: CPUParticles2D = $PastPortalExplosion
@onready var crash_explosion: CPUParticles2D = $crashExplosion

# Ensure portal explosion only used once
var past_portal_explosion_used: bool = false

# Used to determin if as a ghost it is used in a collision
var isActive: bool = true

# Location data will be stored as grid coordinates
var locationData: Array[Vector2]
var currentTween: Tween

func face_movement_direction(lookup: int) -> void:
	# If less than 2 location exists, default to up
	if len(locationData) < 2:
		sprite.rotation = 0
		return
		
	# Look up current and minus previous than rotate to face
	var moveDirection: Vector2
	if lookup < 1:
		moveDirection = locationData[-1] - locationData[-2]
	else:
		moveDirection = locationData[lookup] - locationData[lookup-1]
		
		
	match moveDirection:
		Vector2(0, 1):
			sprite.rotation = PI
		Vector2(1, 0):
			sprite.rotation = PI/2
		Vector2(-1, 0):
			sprite.rotation = 3*PI/2
		# Default to the up direction
		_:
			sprite.rotation = 0

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
	face_movement_direction(-1)
	currentTween = create_tween()
	currentTween.tween_property(self, "position", board.gridToReal(newLocation), tweenTime)

# Set an abritary location for the looper (no tween animation)
func setLocation(newLocation: Vector2) -> void:
	# Ensure any previous movement is completed before moving
	kill_active_tween()
	sprite.show()
	past_portal_explosion_used = false
	isActive = true
	var board = get_parent()
	if board == null:
		printerr("NO PARENT WILL NOT WORK")
		return
	
	position = board.gridToReal(newLocation)

# Assumed they have been correctly reset to the start
func play_tick_location(tick: int) -> void:
	if tick >= len(locationData):
		isActive = false
		sprite.hide()
		
		if !past_portal_explosion_used:
			past_portal_explosion.emitting = true
			past_portal_sound.pitch_scale = 1.2 - randf_range(0,0.4)
			past_portal_sound.play()
			past_portal_explosion_used = true
	else:
		isActive = true
		sprite.show()
	var toCheck: int = tick if tick < len(locationData) else len(locationData)-1
	face_movement_direction(toCheck)
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
	sprite.self_modulate = Color.DARK_GRAY

# Waits for the tween to finish, than kills it
func kill_active_tween() -> void:
	if currentTween != null and currentTween.is_running():
		currentTween.kill()

func reachedPortal() -> void:
	sprite.hide()

func crashed() -> void:
	sprite.hide()
	crash_explosion.emitting = true
