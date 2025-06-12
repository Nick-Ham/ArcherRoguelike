class_name ScalingUtil

const GROWTH_RATE : float = 5.0 # real factor: 1.08447
const INTERVAL : float = 30.0
const REFERENCE_HEALTH : float = 10.0

static func getScaledStat(inBaseValue : float) -> float:
	var scaledValue : float = inBaseValue * getScaleFactor()
	return scaledValue

static func getScaleFactor() -> float:
	var exponent : float = GameTime.getTime() / INTERVAL
	var scaleFactor : float = pow(GROWTH_RATE, exponent)
	return scaleFactor

static func multiplyScaleFactor(inScaleFactor : float, inScalar : float) -> float:
	var baseGrowth : float = inScaleFactor - 1.0
	var newGrowth : float = baseGrowth * inScalar
	return (newGrowth + 1.0)
