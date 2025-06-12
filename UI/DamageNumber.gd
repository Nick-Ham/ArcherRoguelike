extends Node2D
class_name DamageNumber

@export_category("Local")
@export var label : Label = null
@export var animationPlayer : AnimationPlayer = null
@export_category("Config")
@export var healthScaleReference : float = 5.0
@export var minScale : float = 1.3
@export var maxScale : float = 2.5
@export_group("AnimationKeys")
@export var fadeOutAnimationKey : String = "FadeOut"

const xMax : float = 1.5
const yMin : float = 5.0
const yMax : float = 10.0

const speedMin : float = 10.0
const speedMax : float = 15.0

const friction : float = 5.5

@onready var floatDirection : Vector2 = Vector2(randf_range(-xMax, xMax), -randf_range(yMin, yMax))
@onready var floatSpeed : float = randf_range(speedMin, speedMax)

func _ready() -> void:
	assert(label)
	assert(animationPlayer)

func damageToText(inDamage : float) -> String:
	var damageAsString : String = str(clampf(floorf(inDamage), 1.0, inDamage))
	return damageAsString

func start(inDamage : float) -> void:
	label.text = str(damageToText(inDamage))
	animationPlayer.play(fadeOutAnimationKey)

	var scaledHealth : float = ScalingUtil.REFERENCE_HEALTH * ScalingUtil.getScaleFactor()
	var maxScaledHealth : float = scaledHealth * healthScaleReference
	var labelScale : float = remap(inDamage, scaledHealth, maxScaledHealth, minScale, maxScale)

	scale = Vector2(1.0, 1.0) * clampf(labelScale, minScale, maxScale)

func _process(delta: float) -> void:
	global_position += floatDirection * floatSpeed * delta
	floatSpeed *= 1.0 - friction * delta

func kill() -> void:
	queue_free()
