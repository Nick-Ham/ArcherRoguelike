extends CharacterBody2D
class_name Character

signal character_destroyed

enum Team {
	Player,
	Enemy
}

@export_category("Config")
@export var team : Team = Team.Enemy
@export var characterStats : CharacterStats = null

@export_category("Local")
@export var characterCenter : Marker2D = null

func _ready() -> void:
	assert(characterCenter)

	var health : Health = Health.getHealthComponent(self)
	if health:
		health.health_depleted.connect(on_health_depleted)

	loadFromStats()

func loadFromStats() -> void:
	var health : Health = Health.getHealthComponent(self)
	if health:
		health.maxHealth = characterStats.baseHealth
		health.health = characterStats.baseHealth

func on_health_depleted() -> void:
	queue_free()

func getCharacterCenter(useGlobal : bool = false) -> Vector2:
	return characterCenter.global_position if useGlobal else characterCenter.position

func getStats() -> CharacterStats:
	return characterStats

func getSpeedAmp() -> float:
	return characterStats.movementSpeedAmp

static func getOwningCharacter(inContext : Node) -> Character:
	return Util.getParentInTreeOfType(inContext, Character)
