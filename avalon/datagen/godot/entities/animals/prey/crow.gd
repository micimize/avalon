extends Animal
class_name Crow

export var inactive_speed := 1.25
export var inactive_turn_frequency: float = 1.0 / 16

export var active_flee_full_speed := 3.0
export var active_flee_turn_speed := 1.25
export var active_flee_turn_rotation_speed := 1.5


func _ready():
	inactive_behavior = FlyRandomly.new(
		_rng_key("inactive"), inactive_turn_frequency, inactive_speed
	)
	active_behavior = FlyInDirection.new(
		AWAY_FROM_PLAYER,
		active_flee_full_speed,
		active_flee_turn_speed,
		active_flee_turn_rotation_speed
	)
	avoid_ocean_behavior = AvoidOcean.new(
		_rng_key("avoid_ocean"),
		AvoidOcean.FLY_STEPS,
		active_flee_full_speed,
		active_flee_turn_speed
	)


func select_next_behavior() -> AnimalBehavior:
	if is_player_in_detection_radius:
		return active_behavior
	return inactive_behavior
