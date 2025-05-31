extends Projectile
class_name Arrow

@onready var arrowImpactScene : PackedScene = preload("res://Projectiles/Impacts/ArrowImpact.tscn")

@export_category("Config")
@export var arrowCharacterShift : float = 5.0

func handleCharacterHit(hitCharacter : Character, inCollision : KinematicCollision2D) -> void:
	var arrowImpact : TimedImpact = arrowImpactScene.instantiate()

	arrowImpact.global_rotation = global_rotation
	arrowImpact.global_position = inCollision.get_position() - hitCharacter.global_position

	var vectorToCharacter : Vector2 = (hitCharacter.global_position - arrowImpact.global_position).normalized()
	arrowImpact.global_position += vectorToCharacter * arrowCharacterShift

	hitCharacter.add_child(arrowImpact)

	super.handleCharacterHit(hitCharacter, inCollision)

func handleOtherHit(inCollider : Object, inCollision : KinematicCollision2D) -> void:
	var level : Level = Game.getLevel(get_tree())

	var arrowImpact : TimedImpact = arrowImpactScene.instantiate()
	arrowImpact.global_position = inCollision.get_position()
	arrowImpact.global_rotation = global_rotation

	level.add_child(arrowImpact)

	super.handleOtherHit(inCollider, inCollision)
