extends Node2D
class_name Weapon

@onready var owningCharacter : Character = Character.getOwningCharacter(self)
@onready var controller : Controller = Controller.getController(owningCharacter)

@export_category("Local")
@export var pivot : Node2D = null
@export_category("Config")
@export var baseDamageMult : float = 1.0
@export var procCoefficient : float = 1.0
@export_category("Animation")
@export var animationStyle : AnimationStyle = AnimationStyle.MeleeHolster

enum AnimationStyle {
	MeleeHolster,
	Orbit,
}

func on_activate_changed(_isActivating : bool) -> void:
	return

func _ready() -> void:
	assert(pivot)

	z_as_relative = true
	setupWeapon()

func setupWeapon() -> void:
	var characterCenter : Vector2 = owningCharacter.getCharacterCenter()
	position = characterCenter

	if controller:
		bindToController(controller)

	if animationStyle == AnimationStyle.MeleeHolster:
		pivot.z_index = -1

func _process(_delta: float) -> void:
	if !controller:
		return

	updateWeaponPosition()

func bindToController(inController : Controller) -> void:
	inController.activate_changed.connect(on_activate_changed)

func updateWeaponPosition() -> void:
	if animationStyle == AnimationStyle.Orbit:
		orbitWeapon()
		return

	if animationStyle == AnimationStyle.MeleeHolster:
		updateHolster()
		return

func updateHolster() -> void:
	var moveDirection : float = sign(controller.getLastInputDirection().x)

	if !is_zero_approx(moveDirection):
		pivot.scale.x = moveDirection

func orbitWeapon() -> void:
	var aimPosition : Vector2 = controller.getLastAimPosition()
	var aimDirection : Vector2 = (aimPosition - owningCharacter.getCharacterCenter(true)).normalized()

	var newRotation : float = aimDirection.angle()

	z_index = -1 if newRotation < 0 else 1
	rotation = newRotation

func getHolder() -> Character:
	return owningCharacter
