extends Node2D
class_name Cursor

@export_category("Local")
@export var cursorSprite : Sprite2D

@export_category("Config")
@export var controller : Controller = null

func _ready() -> void:
	assert(cursorSprite)

	controller = Controller.getController(Character.getOwningCharacter(self))

	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

	set_as_top_level(true)
	texture_filter = TextureFilter.TEXTURE_FILTER_NEAREST
	refreshCursor()

func _process(_delta: float) -> void:
	refreshCursor()

func refreshCursor() -> void:
	if !controller:
		set_visible(false)
	else:
		set_visible(true)

	var aimDirection : Vector2 = controller.getLastAimPosition()
	global_position = aimDirection
