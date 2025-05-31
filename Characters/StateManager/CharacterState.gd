extends Node
class_name CharacterState

@export_category("Config")
@export var acceleration : float = 1000.0
@export var maxSpeed : float = 45.0
@export var maxSpeedEnforcement : float = 10.0
@export var friction : float = 450.0
@export var slowingFrictionScalar : float = 1.0

signal request_change_state(inStateKey : String)

func getStateKey() -> String:
	return ""

func stateEntering() -> void:
	pass

func stateExiting() -> void:
	pass

func _ready() -> void:
	assert(getStateManager(), "CharacterState must be a child of a StateManager")

func update_physics(delta : float) -> void:
	var character : Character = Character.getOwningCharacter(self)

	var direction : Vector2 = getStateManager().getLastInputDirection()
	var addedVelocity : Vector2 = direction * acceleration * delta

	character.velocity += addedVelocity

	if is_zero_approx(direction.length_squared()):
		character.velocity += getFriction(character.velocity, delta)
	else:
		character.velocity += getFriction(character.velocity, delta, true)

	character.velocity = clampVelocityPlanar(character.velocity, delta)
	character.move_and_slide()

	handleRigidBodyCollisions()

func handleRigidBodyCollisions() -> void:
	var character : Character = Character.getOwningCharacter(self)
	if !character:
		push_error("Must be used on type Character")
		return

	var collisionIndex : int = -1
	var rigidCollider : RigidBody2D = null
	var foundCollision : KinematicCollision2D = null

	for i : int in character.get_slide_collision_count():
		var collision : KinematicCollision2D = character.get_slide_collision(i)
		var colliderAsRigid : RigidBody2D = collision.get_collider() as RigidBody2D
		if !colliderAsRigid:
			continue

		foundCollision  = collision
		rigidCollider = colliderAsRigid
		collisionIndex = i
		break

	if collisionIndex == -1:
		return

	var pushStrength : float = character.mass * character.get_position_delta().length()
	var pushForce : Vector2 = pushStrength * -foundCollision.get_normal()
	rigidCollider.apply_impulse(pushForce, foundCollision.get_position())

func clampVelocityPlanar(inVelocity : Vector2, delta : float) -> Vector2:
	var velocity : Vector2 = inVelocity
	velocity = lerp(velocity, velocity.limit_length(maxSpeed), maxSpeedEnforcement * delta)

	return velocity

func getFriction(inVelocity : Vector2, inDelta : float, isAccelerating : bool = false) -> Vector2:
	var speed : float = inVelocity.length()

	var scaledFriction : float = friction if isAccelerating else friction * slowingFrictionScalar
	var totalFriction : Vector2 = clamp(inDelta * scaledFriction, 0.0, speed) * -inVelocity.normalized()

	return totalFriction

func getStateManager() -> CharacterStateManager:
	return get_parent() as CharacterStateManager

func getLeanDirection() -> Vector2:
	return Vector2(getStateManager().getLastInputDirection().x, 0)
