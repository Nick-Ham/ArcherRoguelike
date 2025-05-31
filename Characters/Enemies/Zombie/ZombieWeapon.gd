extends Weapon
class_name ZombieWeapon

@export_category("Local")
@export var attackHitbox : Area2D = null
@export var cooldownTimer : Timer = null

@export_category("Config")
@export var selfKnockback : float = 500.0
@export var targetKnockback : float = 200.0
@export var attackCooldown : float = 1.0

func _ready() -> void:
	assert(attackHitbox)
	assert(cooldownTimer)

	cooldownTimer.wait_time = attackCooldown

	attackHitbox.body_entered.connect(on_attackHitbox_body_entered)
	cooldownTimer.timeout.connect(on_cooldownTimer_timeout)

func on_cooldownTimer_timeout() -> void:
	# theres a chance to end up unable to attack if for instance, the knockback doesnt make the player leave the hitbox
	# and they never are able to re-trigger body_entered... ignoring for now
	return

func on_attackHitbox_body_entered(inBody : Node2D) -> void:
	var hitCharacter : Character = inBody
	if !hitCharacter:
		return

	if hitCharacter == owningCharacter:
		return

	if hitCharacter.team == owningCharacter.team:
		return

	var newAttackInfo : AttackUtil.AttackInfo = AttackUtil.makeAttack(self, baseDamageMult, procCoefficient)

	var health : Health = Health.getHealthComponent(hitCharacter)
	if health:
		health.takeDamage(AttackUtil.calculateDamage(newAttackInfo))

	var vectorToHitCharacter : Vector2 = (hitCharacter.global_position - owningCharacter.global_position).normalized()

	owningCharacter.velocity += -vectorToHitCharacter * selfKnockback
	hitCharacter.velocity += vectorToHitCharacter * targetKnockback
