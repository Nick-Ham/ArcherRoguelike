extends TimedImpact
class_name ArrowImpact

@export_category("Config")
@export_range(0.0, 90.0) var randomRotationDegrees : float = 20.0

func _ready() -> void:
	global_rotation += deg_to_rad(randf_range(-randomRotationDegrees, randomRotationDegrees))
