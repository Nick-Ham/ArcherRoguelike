extends Node

@onready var zombiePacked : PackedScene = preload("res://Characters/Enemies/Zombie/Zombie.tscn")
@onready var eyeSquidPacked : PackedScene = preload("res://Characters/Enemies/EyeSquid/EyeSquid.tscn")

@onready var enemyCosts : Dictionary = {
	zombiePacked : 2.0,
	#eyeSquidPacked : 6.0,
}

func getSpawnableEnemies() -> Array:
	return enemyCosts.keys()

func getEnemyCost(inScene : PackedScene) -> float:
	return enemyCosts[inScene]
