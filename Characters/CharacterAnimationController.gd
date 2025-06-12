extends Node
class_name CharacterAnimationController

@export_category("Local")
@export var animatedSprite : AnimatedSprite2D = null
@export var stateManager : CharacterStateManager = null
@export var animationPlayer : AnimationPlayer

@export_category("Config")
@export_group("Lean")
@export var leanAngle : float = 10.0
@export var leanLerpSpeed : float = 55.0
@export var maxLean : float = 85.0
@export_group("Animation")
@export var flipSpriteOnMovement : bool = true
@export_group("Idle")
@export var idleAnimationKey : String = "idle"
@export_group("Walking")
@export var useWalkAnimation : bool = true
@export var walkAnimationKey : String = "walk"
@export_group("AnimationKeys")
@export var hitFlashKey : String = "HitFlash"

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var healthComponent : Health = Util.getChildOfType(owningCharacter, Health)

@onready var damageNumberScene : PackedScene = preload("res://UI/DamageNumber.tscn")

func _ready() -> void:
	assert(animatedSprite)
	assert(stateManager)

	if healthComponent:
		healthComponent.health_changed.connect(on_health_changed)

func on_health_changed(lastHealth : float, newHealth : float) -> void:
	if newHealth < lastHealth:
		animationPlayer.play(hitFlashKey)
		makeDamageNumber(lastHealth - newHealth)

func makeDamageNumber(inDamage : float) -> void:
	var damageNumberInstance : DamageNumber = damageNumberScene.instantiate()
	damageNumberInstance.start(inDamage)

	damageNumberInstance.global_position = owningCharacter.getCharacterCenter(true)

	var level : Level = Game.getLevel(get_tree())
	level.add_child(damageNumberInstance)

func _process(delta: float) -> void:
	updateLean(delta)
	updateSpriteDirection()
	updateAnimation()

func updateAnimation() -> void:
	var inputDirection : Vector2 = stateManager.getLastInputDirection()
	if inputDirection.is_zero_approx() || !useWalkAnimation:
		animatedSprite.play(idleAnimationKey)
		return

	animatedSprite.play(walkAnimationKey)

func updateSpriteDirection() -> void:
	if !flipSpriteOnMovement:
		return

	var inputDirection : Vector2 = stateManager.getLastInputDirection()
	if is_zero_approx(inputDirection.x):
		return

	animatedSprite.flip_h = inputDirection.x < 0

func updateLean(inDelta: float) -> void:
	animatedSprite.rotation_degrees = lerp(animatedSprite.rotation_degrees, (getSpeedFraction() * leanAngle * sign(owningCharacter.velocity.x)), leanLerpSpeed * inDelta)
	animatedSprite.rotation_degrees = clampf(animatedSprite.rotation_degrees, -maxLean, maxLean)

func getSpeedFraction() -> float:
	var xSpeed : float = abs(owningCharacter.velocity.x)
	var speedFraction : float = xSpeed / stateManager.getCurrentMaxSpeed()

	return speedFraction
