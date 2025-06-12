extends Node
class_name SpawnDirector

@export_category("Config")
@export var disabled : bool = false
@export var spawnTimeInterval : float = 5.0 #15.0
@export var maxEntityPerSpawn : int = 10
@export var baseBudget : float = 10.0
@export var income : float = 0.5
@export var incomeScaleFactorAmp : float = 2.0
@export var printDebug : bool = false

@onready var spawnTimer : Timer = Timer.new()

const maxSpawnAttempts : int = 15
const spawnTimerSpeed : float = 0.5

var budget : float = 5.0
var lastSpawnTime : float = 0.0

var spawnQueue : Array[SpawnInfo] = []

class SpawnInfo:
	var enemyPacked : PackedScene = null
	var quantity : int = 0
	var isElite : bool = false

func _ready() -> void:
	setupSpawnTimer()

func setupSpawnTimer() -> void:
	spawnTimer.autostart = false
	spawnTimer.one_shot = false
	spawnTimer.wait_time = spawnTimerSpeed
	spawnTimer.timeout.connect(on_spawnTimer_timeout)

	add_child(spawnTimer)
	spawnTimer.start()

func on_spawnTimer_timeout() -> void:
	if disabled:
		return

	if spawnQueue.is_empty():
		return

	var currentSpawnInfo : SpawnInfo = spawnQueue.back()
	var level : Level = Game.getLevel(get_tree())
	var levelSpawnManager : LevelSpawnManager = Util.getChildOfType(level, LevelSpawnManager)

	levelSpawnManager.spawnEnemy(currentSpawnInfo.enemyPacked)

	currentSpawnInfo.quantity -= 1
	if currentSpawnInfo.quantity <= 0:
		spawnQueue.pop_back()

func _process(delta: float) -> void:
	if disabled:
		return

	budget += delta * ScalingUtil.multiplyScaleFactor(ScalingUtil.getScaleFactor(), incomeScaleFactorAmp) * income

	if printDebug:
		printDebugInfo()

	if spawnTimeElapsed():
		generateSpawnQueue()

func spawnTimeElapsed() -> bool:
	return GameTime.getTime() - lastSpawnTime > spawnTimeInterval

func generateSpawnQueue() -> void:
	var newSpawnQueue : Array[SpawnInfo]

	for spawnAttempts : int in range(maxSpawnAttempts):
		var enemyPacked : PackedScene = SpawnCatalog.getSpawnableEnemies().pick_random() as PackedScene
		var enemyCost : float = SpawnCatalog.getEnemyCost(enemyPacked)

		var spawnCount : int = 0
		for entitySpawn : int in range(maxEntityPerSpawn):
			if budget < enemyCost:
				break

			spawnCount += 1
			budget -= enemyCost

		if spawnCount <= 0:
			continue

		var newSpawnInfo : SpawnInfo = SpawnInfo.new()
		newSpawnInfo.enemyPacked = enemyPacked
		newSpawnInfo.quantity = spawnCount

		# try converting to elite

		newSpawnQueue.append(newSpawnInfo)

	spawnQueue.append_array(newSpawnQueue)
	lastSpawnTime = GameTime.getTime()

func printDebugInfo() -> void:
	var timeAsString : String = "T: " + str(GameTime.getTime())
	var scaleFactorAsString : String = "S: " + str(ScalingUtil.getScaleFactor())
	var budgetString : String = "B: " + str(budget)

	print(timeAsString + " " + scaleFactorAsString + " " + budgetString)
