extends Controller
class_name ZombieController

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)

var lastInputDirection : Vector2 = Vector2()
var lastAimPosition : Vector2 = Vector2()

func _ready() -> void:
	assert(targeter)

func _process(_delta: float) -> void:
	var target : Character = targeter.getTarget()
	if !target:
		return

	lastInputDirection = (target.global_position - owningCharacter.global_position).normalized()
	lastAimPosition = owningCharacter.global_position

	input_direction_changed.emit(lastInputDirection)

func getLastInputDirection() -> Vector2:
	return lastInputDirection

func getLastAimPosition() -> Vector2:
	return lastAimPosition

func getIsActivating() -> bool:
	return false
