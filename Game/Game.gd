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

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		get_tree().quit()

	if Input.is_action_just_pressed("F1"):
		get_tree().reload_current_scene()

static func getGame(inTree : SceneTree) -> Game:
	var game : Game = inTree.current_scene as Game
	return game

static func getLevel(inTree : SceneTree) -> Level:
	var game : Game = getGame(inTree)
	return game.getCurrentLevel()
