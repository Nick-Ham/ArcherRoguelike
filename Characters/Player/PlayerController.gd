extends Controller
class_name PlayerController

@export_category("Config")
@export var playerCamera : Camera2D = null

var isActivating : bool = false

func _ready() -> void:
	super._ready()

	assert(playerCamera)
	playerCamera.make_current()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		activate_changed.emit(true)
	elif event is InputEventMouseButton and !event.is_pressed():
		activate_changed.emit(false)

func _process(_delta: float) -> void:
	var rawDirection : Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	input_direction_changed.emit(rawDirection)
	lastInputDirection = rawDirection

	var mousePosition : Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	aim_position_changed.emit(mousePosition)
	lastAimPosition = mousePosition

func getLastInputDirection() -> Vector2:
	return lastInputDirection

func getLastAimPosition() -> Vector2:
	return lastAimPosition

func getIsActivating() -> bool:
	return isActivating
