extends Node
class_name Targeter

@export_category("Config")
@export var targetArea : Area2D = null
@export var behaviorTreePlayer : BTPlayer
@export_group("Collision")
@export_flags_2d_physics var characterMaskLayer : int = 2

@onready var owningCharacter : Character = Character.getOwningCharacter(self)

var target : Character = null
var targetVar : String = &"target"

func _ready() -> void:
	assert(targetArea)
	assert(behaviorTreePlayer)

	fetchTarget()
	bindToArea()

func bindToArea() -> void:
	targetArea.body_entered.connect(on_targetArea_body_entered)
	for body : Node in targetArea.get_overlapping_bodies():
		handleNewTarget(body)

func handleNewTarget(inBody : Node) -> void:
	var inBodyAsCharacter : Character = inBody as Character
	if !inBodyAsCharacter:
		return

	if inBodyAsCharacter.team == owningCharacter.team:
		return

	target = inBodyAsCharacter
	behaviorTreePlayer.blackboard.set_var(targetVar, target)

func on_targetArea_body_entered(inBody : Node) -> void:
	handleNewTarget(inBody)

func getTarget() -> Character:
	if !target:
		fetchTarget()

	return target

func fetchTarget() -> void:
	var level : Level = Game.getLevel(get_tree())
	target = level.getPlayer()
