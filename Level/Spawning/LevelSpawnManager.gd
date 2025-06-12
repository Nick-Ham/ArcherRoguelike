extends Node2D
class_name LevelSpawnManager

@export_category("Local")
@export var tileMap : TileMapLayer
@export_category("Config")
@export var minDistanceFromBlocker : float = 100.0
@export var spawnRadius : float = 10.0
@export var debugDraw : bool = false
@export_group("CustomDataLayers")
@export var spawnableLayerKey : String = "Spawnable"

var spawnableTiles : Array[Vector2i] = []

const tooCloseColor : Color = Color.DARK_RED
const validColor : Color = Color.CHARTREUSE

func _ready() -> void:
	assert(tileMap)
	generateSpawnableTileArray()

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if debugDraw:
		drawDebugInfo()

func spawnEnemy(inEnemyPacked : PackedScene) -> void:
	var level : Level = Game.getLevel(get_tree())
	var player : Character = level.getPlayer()

	var spawnReadyTiles : Array[Vector2i] = []

	if is_instance_valid(player) and !player.is_queued_for_deletion():
		spawnReadyTiles = getReadyToSpawnTiles(player.global_position)
	else:
		spawnReadyTiles = spawnableTiles

	var tile : Vector2i = spawnReadyTiles.pick_random()

	var tileGlobalPosition : Vector2 = tileMap.map_to_local(tile) + tileMap.global_position
	var spawnPosition : Vector2 = RandUtil.getRandomOffset(spawnRadius) + tileGlobalPosition

	var newEnemyInstance : Character = inEnemyPacked.instantiate()
	newEnemyInstance.global_position = spawnPosition
	newEnemyInstance.setScaleFactor(ScalingUtil.getScaleFactor())

	level.add_child(newEnemyInstance)

func drawDebugInfo() -> void:
	var level : Level = Game.getLevel(get_tree())

	for tile : Vector2i in spawnableTiles:
		var tileGlobalPosition : Vector2 = tileMap.map_to_local(tile) + tileMap.global_position
		draw_circle(tileGlobalPosition, 3.0, tooCloseColor, true)

	for tile : Vector2i in getReadyToSpawnTiles(level.getPlayer().global_position):
		var tileGlobalPosition : Vector2 = tileMap.map_to_local(tile) + tileMap.global_position
		draw_circle(tileGlobalPosition, 5.0, validColor, true)

func getReadyToSpawnTiles(inPlayerPosition : Vector2) -> Array[Vector2i]:
	var readyToSpawnTiles : Array[Vector2i] = []

	for tile : Vector2i in spawnableTiles:
		var tileGlobalPosition : Vector2 = tileMap.map_to_local(tile) + tileMap.global_position
		if pow(minDistanceFromBlocker, 2) < tileGlobalPosition.distance_squared_to(inPlayerPosition):
			readyToSpawnTiles.append(tile)

	return readyToSpawnTiles

func generateSpawnableTileArray() -> void:
	var usedCells : Array[Vector2i] = tileMap.get_used_cells()

	var spawnableCells : Array[Vector2i] = []
	for cell : Vector2i in usedCells:
		var tileData : TileData = tileMap.get_cell_tile_data(cell)
		var isSpawnable : bool = tileData.get_custom_data(spawnableLayerKey)

		if isSpawnable:
			spawnableCells.append(cell)

	spawnableTiles = spawnableCells
