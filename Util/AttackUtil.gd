class_name AttackUtil

class AttackInfo extends RefCounted:
	# Source data
	var sourceCharacter : Character = null
	var sourceWeapon : Weapon = null

	# Attack data
	var baseDamage : float = 0.0
	var weaponDamageMult : float = 0.0
	var procCoefficient : float = 0.0

static func makeAttack(inWeapon : Weapon, inDamageMult : float, inProcCoefficient : float) -> AttackInfo:
	var newAttackInfo : AttackInfo = AttackInfo.new()

	newAttackInfo.sourceCharacter = inWeapon.getHolder()
	newAttackInfo.sourceWeapon = inWeapon

	var characterStats : CharacterStats = newAttackInfo.sourceCharacter.getStats()

	newAttackInfo.baseDamage = characterStats.baseDamage
	newAttackInfo.weaponDamageMult = inDamageMult
	newAttackInfo.procCoefficient = inProcCoefficient

	return newAttackInfo

static func applyHitEffects(_inAttackInfo : AttackInfo, _inHitCharacter : Character) -> void:
	return

static func calculateDamage(inAttackInfo : AttackInfo) -> float:
	var totalDamage : float = inAttackInfo.baseDamage

	totalDamage *= inAttackInfo.weaponDamageMult

	return totalDamage
