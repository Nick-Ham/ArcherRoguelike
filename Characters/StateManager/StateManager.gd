extends Node
class_name CharacterStateManager

@export_category("Config")
@export var enableLogging : bool = false
@export var loggerCategory : String = "Player:StateManager:State"

@export_category("States")
@export var stateDefault : CharacterStateDefault
@export var stateDestroyed : CharacterStateDestroyed

@onready var states : Array[CharacterState] = [
	stateDefault,
	stateDestroyed
]

var character : Character = null
var controller : Controller = null
var lastState : CharacterState = null
var currentState : CharacterState = null
var lastInputDirection : Vector2 = Vector2()

signal state_changed(lastState : CharacterState, newState : CharacterState)
signal head_punch_triggered(punch : Vector2)

const minSpeed : float = 0.08

const maxDelta : float = 0.1
const updatePhysicsInProcess : bool = false

func _ready() -> void:
	if !character:
		character = get_parent() as Character

	assert(character)

	character.velocity = Vector2()

	assert(character, "CharacterStateManager only valid on a Character2D")

	controller = Controller.getController(character)
	if controller:
		bindToController(controller)

	Util.safeConnect(character.character_destroyed, on_character_destroyed)

	bindToStates()

	changeState(stateDefault)

func on_character_destroyed(_inCharacter : Character) -> void:
	lastInputDirection = Vector2()

func forceChangeState(inStateKey : String) -> void:
	# might want to do something different later
	for state : CharacterState in states:
		if state.getStateKey() == inStateKey:
			changeState(state)
			break

func addController(inController : Controller) -> void:
	if !inController:
		return

	controller = inController
	bindToController(inController)

func bindToController(inController : Controller) -> void:
	Util.safeConnect(inController.input_direction_changed, on_input_direction_changed)

func on_input_direction_changed(inputDirection : Vector2) -> void:
	lastInputDirection = inputDirection

func on_jump_changed(inIsJumping : bool) -> void:
	currentState.handleOnJumpChanged(inIsJumping)

func _process(delta: float) -> void:
	if updatePhysicsInProcess:
		currentState.update_physics(clampf(delta, 0.0, maxDelta))

func _physics_process(delta: float) -> void:
	if !updatePhysicsInProcess:
		currentState.update_physics(delta)

func getCharacterController() -> Controller:
	return Controller.getController(character)

func getLastInputDirection() -> Vector2:
	return lastInputDirection

func changeState(inNewState : CharacterState) -> void:
	if currentState != null:
		currentState.stateExiting()

	lastState = currentState

	currentState = inNewState
	currentState.stateEntering()

	state_changed.emit(lastState, currentState)

func on_request_change_state(inStateKey : String) -> void:
	for state : CharacterState in states:
		if state.getStateKey() == inStateKey:
			changeState(state)
			break

func bindToStates() -> void:
	for state : CharacterState in states:
		state.request_change_state.connect(on_request_change_state)

func getCurrentMaxSpeed() -> float:
	return currentState.maxSpeed

func getCurrentSpeed() -> float:
	var speed : float = character.velocity.length()
	if speed < minSpeed:
		return 0.0

	return speed

func getCurrentState() -> CharacterState:
	return currentState

func getMinimumSpeed() -> float:
	return minSpeed
