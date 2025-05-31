extends Area2D
class_name PushArea

@export_category("Config")
@export var pushForce : float = 500.0
@export_flags_2d_physics var pushCollisionBit : int = 32

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

func _physics_process(delta: float) -> void:
	var overlappingAreas : Array[Area2D] = get_overlapping_areas()
	if overlappingAreas.is_empty():
		return

	var nearbyCharacter : Character = Character.getOwningCharacter(overlappingAreas[0])
	if !nearbyCharacter:
		return

	var vectorToNearest : Vector2 = (nearbyCharacter.global_position - owningCharacter.global_position).normalized()
	owningCharacter.velocity += -vectorToNearest * pushForce * delta
