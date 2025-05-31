extends Weapon
class_name BowWeapon

@onready var arrowScene : PackedScene = preload("res://Projectiles/Arrow.tscn")

@export_category("Local")
@export var sprite : AnimatedSprite2D
@export var chargeTimer : Timer
@export var spawnMarker : Marker2D
@export var chargeFlashAnimationPlayer : AnimationPlayer

@export_category("Config")
@export_group("Behavior")
@export var chargeTime : float = 0.75
@export var isRepeating : bool = false
@export_group("Accuracy")
@export var useSpread : bool = true
@export var spread : float = 5.0
@export_group("Animation")
@export var idleKey : String = "default"
@export var chargingKey : String = "charging"
@export var chargedKey : String = "charged"
@export var chargeFlashKey : String = "chargedFlash"
@export var flashSpeedScale : float = 1.0

const resetKey : String = "RESET"

var isCharging : bool = false
var canFire : bool = false

func _ready() -> void:
	assert(sprite)
	assert(chargeTimer)
	assert(spawnMarker)
	assert(chargeFlashAnimationPlayer)

	super._ready()

	setupCharge()

	chargeTimer.timeout.connect(on_chargeTimer_timeout)

func setupCharge() -> void:
	sprite.play(idleKey)

	chargeTimer.wait_time = chargeTime
	sprite.speed_scale = 1.0 / chargeTime

func _process(delta: float) -> void:
	super._process(delta)

func on_activate_changed(isActivating : bool) -> void:
	if isActivating:
		startCharging()
	else:
		stopCharging()

func startCharging() -> void:
	if isCharging:
		return

	isCharging = true
	chargeTimer.start(chargeTime)
	sprite.play(chargingKey)

func stopCharging() -> void:
	if !isCharging:
		return

	isCharging = false
	chargeTimer.stop()
	sprite.play(idleKey)

	if canFire:
		fire()

func fire() -> void:
	canFire = false

	var level : Level = Game.getLevel(get_tree())
	var newArrowInstance : Arrow = arrowScene.instantiate()

	newArrowInstance.global_position = spawnMarker.global_position
	newArrowInstance.global_rotation = global_rotation

	newArrowInstance.rotate(getSpreadAngle())

	level.add_child(newArrowInstance)

	var newAttackInfo : AttackUtil.AttackInfo = AttackUtil.makeAttack(self, baseDamageMult, procCoefficient)
	newArrowInstance.activate(newAttackInfo)

	chargeFlashAnimationPlayer.play(resetKey)

func getSpreadAngle() -> float:
	if !useSpread:
		return 0.0

	var randSpread : float = clampf(randfn(0.0, 0.4) * spread, -spread / 2.0, spread / 2.0)
	return deg_to_rad(randSpread)

func on_chargeTimer_timeout() -> void:
	if !isCharging:
		return

	canFire = true
	chargeFlashAnimationPlayer.play(chargeFlashKey, -1, flashSpeedScale)
	sprite.play(chargedKey)

	if isRepeating:
		stopCharging()
		startCharging()
