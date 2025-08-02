extends AnimatedSprite2D

@onready var portal_explosion: CPUParticles2D = $PortalExplosion

func looperEnteredPortal() -> void:
	portal_explosion.emitting = true
