extends Controller
class_name ZombieController

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var targeter : Targeter = Util.getChildOfType(owningCharacter, Targeter)

func _ready() -> void:
	return

func _physics_process(_delta: float) -> void:
	input_direction_changed.emit(lastInputDirection)
	aim_position_changed.emit()

func getLastInputDirection() -> Vector2:
	return lastInputDirection

func getLastAimPosition() -> Vector2:
	return lastAimPosition

func getIsActivating() -> bool:
	return false
