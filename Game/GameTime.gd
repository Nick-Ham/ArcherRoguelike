extends Node

var gameTime : float = 0.0

func _process(delta: float) -> void:
	tickTime(delta)

func getTime() -> float:
	return gameTime

func tickTime(delta: float) -> void:
	gameTime += delta
