extends Node
class_name Health

@export_category("Config")
@export var health : float = 100
@export var maxHealth : float = 100

signal health_changed(lastHealth : float, newHealth : float)
signal health_depleted

static func getHealthComponent(inCharacter : Character) -> Health:
	return Util.getChildOfType(inCharacter, Health)

func isHealthDepleted() -> bool:
	return health < 0 or is_zero_approx(health)

func takeDamage(inDamage : float) -> void:
	if isHealthDepleted():
		return

	var previousHealth : float = health

	health -= inDamage
	health_changed.emit(previousHealth, health)

	if isHealthDepleted():
		health_depleted.emit()

	health = clampf(health, 0, maxHealth)
