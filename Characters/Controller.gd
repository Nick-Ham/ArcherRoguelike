extends Node
class_name Controller

signal input_direction_changed(inDirection : Vector2)
signal aim_position_changed(inPosition : Vector2)
signal activate_changed(inIsActivating : bool)

var lastInputDirection : Vector2 = Vector2()
var lastAimPosition : Vector2 = Vector2()

func _ready() -> void:
	var owningCharacter : Character = Character.getOwningCharacter(self)
	if !owningCharacter:
		push_warning("Controller will not function unless added to a controllable Character.", self.name)
		return

static func getController(inCharacter : Character) -> Controller:
	if !is_instance_valid(inCharacter):
		return null

	return Util.getChildOfType(inCharacter, Controller)

func getLastInputDirection() -> Vector2:
	push_warning("Last input direction will be empty. Override getLastInputDirection.")
	return Vector2()

func getLastAimPosition() -> Vector2:
	push_warning("Last aim direction will be empty. Override getLastAimDirection.")
	return Vector2()

func getIsActivating() -> bool:
	push_warning("IsActivating will always be false. Override getIsActivating.")
	return false

func setNewInputDirection(inDirection : Vector2) -> void:
	lastInputDirection = inDirection

func setNewAimPosition(inPosition : Vector2) -> void:
	lastAimPosition = inPosition
