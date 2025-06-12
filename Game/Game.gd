extends Node
class_name Game

@export_category("Config")
@export var initialLevelPacked : PackedScene = null

var currentLevel : Level = null

func _ready() -> void:
	assert(initialLevelPacked)

	initializeLevel(initialLevelPacked)

func initializeLevel(inLevelPacked : PackedScene) -> void:
	if currentLevel:
		currentLevel.queue_free()

	currentLevel = inLevelPacked.instantiate()
	add_child(currentLevel)

func getCurrentLevel() -> Level:
	return currentLevel

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("F1"):
		get_tree().reload_current_scene()

	if event.is_action_pressed("Escape"):
		get_tree().quit()

static func getGame(inTree : SceneTree) -> Game:
	var game : Game = inTree.current_scene as Game
	return game

static func getLevel(inTree : SceneTree) -> Level:
	var game : Game = getGame(inTree)
	return game.getCurrentLevel()
