@tool
extends BTAction

@export var controllerVar : String = &"controller"

func _generate_name() -> String:
	return "SetupEnemy"

func _setup() -> void:
	return

func _tick(_delta: float) -> Status:
	var agentAsCharacter : Character = agent as Character
	if !agentAsCharacter:
		push_error("No character agent found.")
		return Status.FAILURE

	var controller : Controller = Controller.getController(agentAsCharacter)
	if !controller:
		push_error("BT will not work without a controller to bind.")
		return Status.FAILURE

	blackboard.set_var(controllerVar, controller)
	return Status.SUCCESS
