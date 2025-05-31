extends CharacterAnimationController
class_name ZombieAnimationController

@export_category("Config")
@export var randomAnimationSpeedUpperRange : float = 2.0
@export var randomAnimationSpeedLowerRange : float = 0.3


func _ready() -> void:
	super._ready()

	animatedSprite.speed_scale = randf_range(randomAnimationSpeedLowerRange, randomAnimationSpeedUpperRange)
