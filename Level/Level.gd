extends Node2D
class_name Level

@onready var playerScene : PackedScene = preload("res://Characters/Player/Player.tscn")



@export_category("Config")
@export var playerSpawn : Marker2D = null

var player : Character = null

func _ready() -> void:
	setupPlayer()

func getPlayer() -> Character:
	return player

func setupPlayer() -> void:
	var newPlayerScene : Character = playerScene.instantiate()
	player = newPlayerScene
	player.global_position = playerSpawn.global_position
	add_child(player)
