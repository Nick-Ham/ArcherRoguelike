extends CharacterBody2D
class_name Projectile

@export_category("Config")
@export var speed : float = 100.0

var attackInfo : AttackUtil.AttackInfo = null

func activate(inAttackInfo : AttackUtil.AttackInfo) -> void:
	var relativeDirection : Vector2 = Vector2.RIGHT.rotated(global_rotation)
	velocity += relativeDirection * speed
	attackInfo = inAttackInfo

func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		handleCollision(collision)

func handleCollision(inCollision : KinematicCollision2D) -> void:
	var collider : Object = inCollision.get_collider()

	var colliderAsCharacter : Character = collider as Character
	if colliderAsCharacter:
		handleCharacterHit(colliderAsCharacter, inCollision)
	else:
		handleOtherHit(collider, inCollision)

	queue_free()

func handleCharacterHit(hitCharacter : Character, _inCollision : KinematicCollision2D) -> void:
	assert(attackInfo)

	var health : Health = Health.getHealthComponent(hitCharacter)
	if health:
		health.takeDamage(AttackUtil.calculateDamage(attackInfo))

	AttackUtil.applyHitEffects(attackInfo, hitCharacter)

func handleOtherHit(_inCollider : Object, _inCollision : KinematicCollision2D) -> void:
	return
