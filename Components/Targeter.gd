extends Node
class_name Targeter

var target : Character = null

func _ready() -> void:
	fetchTarget()

func getTarget() -> Character:
	if !target:
		fetchTarget()

	return target

func fetchTarget() -> void:
	var level : Level = Game.getLevel(get_tree())
	target = level.getPlayer()
