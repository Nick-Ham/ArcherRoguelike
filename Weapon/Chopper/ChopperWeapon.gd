extends Weapon
class_name ChopperWeapon

@export_category("Local")
@export var holsterAnimationPlayer : AnimationPlayer = null
@export var attackAnimationPlayer : AnimationPlayer = null
@export var attackPivot : Node2D = null
@export var attackProgressBar : TextureProgressBar = null
@export var attackHitbox : Area2D = null
@export var comboDelayTimer : Timer = null
@export_category("Config")
@export_group("Behavior")
@export var unlimitedCombo : bool = false
@export var comboLength : int = 3
@export var comboDelay : float = 0.6
@export var characterMotion : float = 90.0
@export var knockback : float = 250.0
@export var baseSwingSpeed : float = 1.0
@export_group("AnimationKeys")
@export var fadeOutAnimation : String = "FadeOut"
@export var fadeInAnimation : String = "FadeIn"
@export var attackAnimation : String = "Attack1"
@export_group("SwipeFrames")
@export var swipeFx1 : Texture2D = null
@export var swipeFx2 : Texture2D = null
@export var swipeFx3 : Texture2D = null

@onready var swipeFX : Array[Texture] = [
	swipeFx1,
	swipeFx2,
	swipeFx3
]

var continueAttacking : bool = false
var currentCombo : int = 0
var hitThisAttack : Array[Character] = []

func on_activate_changed(isActivating : bool) -> void:
	if !isActivating:
		if continueAttacking:
			continueAttacking = false
		return

	if isActivating and !isAttacking() and comboDelayTimer.is_stopped():
		attack()
	else:
		continueAttacking = true

func isAttacking() -> bool:
	return attackAnimationPlayer.is_playing()

func _ready() -> void:
	assert(attackPivot)
	assert(holsterAnimationPlayer)
	assert(attackAnimationPlayer)
	assert(attackHitbox)
	assert(comboDelayTimer)
	super._ready()

	attackAnimationPlayer.animation_finished.connect(on_attackAnimationPlayer_animation_finished)
	comboDelayTimer.timeout.connect(on_comboDelayTimer_timeout)

func on_comboDelayTimer_timeout() -> void:
	if continueAttacking:
		attack()
	else:
		holsterAnimationPlayer.play(fadeInAnimation)

func on_attackAnimationPlayer_animation_finished(_inAnimationName : String) -> void:
	if !continueAttacking or currentCombo >= comboLength:

		var attackSpeed : float = owningCharacter.getStats().attackSpeed
		comboDelayTimer.start(comboDelay * (1.0 / attackSpeed))

		stopCombo()
		return

	attack()

func stopCombo() -> void:
	currentCombo = 0
	attackPivot.scale.y = 1.0
	attackPivot.rotation = 0.0

func attack() -> void:
	hitThisAttack.clear()

	var attackSpeed : float = owningCharacter.getStats().attackSpeed
	attackAnimationPlayer.speed_scale = attackSpeed * baseSwingSpeed

	var directionTo : Vector2 = (controller.getLastAimPosition() - owningCharacter.global_position).normalized()
	var angleTo : float = directionTo.angle()

	attackPivot.rotation = angleTo
	attackPivot.scale.y = -1.0 if currentCombo % 2 == 0 else 1.0

	if !continueAttacking:
		holsterAnimationPlayer.play(fadeOutAnimation)

	attackAnimationPlayer.play(attackAnimation)

	continueAttacking = true
	currentCombo += 1

	if unlimitedCombo:
		currentCombo = currentCombo % 2

func checkForHits() -> void:
	var overlappingBodies : Array[Node2D] = attackHitbox.get_overlapping_bodies()

	for body : Node2D in overlappingBodies:
		var bodyAsCharacter : Character = body as Character
		if !bodyAsCharacter:
			continue

		if hitThisAttack.has(bodyAsCharacter):
			return

		if bodyAsCharacter == owningCharacter:
			continue

		if bodyAsCharacter.team == owningCharacter.team:
			continue

		hitCharacter(bodyAsCharacter)
		hitThisAttack.append(bodyAsCharacter)

func hitCharacter(inCharacter : Character) -> void:
	var newAttackInfo : AttackUtil.AttackInfo = AttackUtil.makeAttack(self, baseDamageMult, procCoefficient)

	var health : Health = Health.getHealthComponent(inCharacter)
	if health:
		health.takeDamage(AttackUtil.calculateDamage(newAttackInfo))

	var directionTo : Vector2 = (inCharacter.global_position - owningCharacter.global_position).normalized()
	inCharacter.velocity += directionTo * knockback

	AttackUtil.applyHitEffects(newAttackInfo, inCharacter)

func applyCharacterMotion() -> void:
	var directionTo : Vector2 = (controller.getLastAimPosition() - owningCharacter.global_position).normalized()
	owningCharacter.velocity += directionTo * characterMotion

func setSwipeFXTexture(inIndex : int) -> void:
	if inIndex >= swipeFX.size() || inIndex < 0:
		push_error("Out of bounds texture index.")
		return

	attackProgressBar.set_progress_texture(swipeFX[inIndex])
