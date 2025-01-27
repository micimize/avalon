extends Predator
class_name Hippo

export var out_of_reach_height = 4
export var required_movement_distance = 2
export var give_up_after_hops_without_progress = 32

export var inactive_avoid_speed := Vector2(1.5, 1.5)
export var inactive_avoid_hops := 4
export var inactive_rest_frames := 8

export var active_within_threshold := 6.0

export var active_chase_speed := Vector2(3.25, 1.25)
export var active_chase_hops := 8
export var active_rest_frames := 4

var activation_criteria: ActivationGate


func _ready():
	var player_in_detection_radius = PlayerInDetectionRadius.new()
	var continued_activation_criteria := [
		player_in_detection_radius,
		PlayerReachableByGround.new(
			out_of_reach_height, required_movement_distance, give_up_after_hops_without_progress
		),
	]
	var initial_activation_criteria := [PlayerWithinThreshold.new(active_within_threshold)]
	activation_criteria = ActivationGate.new(
		continued_activation_criteria, initial_activation_criteria
	)

	inactive_behavior = ConditionalBehavior.new(
		[player_in_detection_radius],
		HopInDirection.new(
			AWAY_FROM_PLAYER, inactive_avoid_speed, inactive_avoid_hops, inactive_rest_frames
		)
	)

	active_behavior = PursueAndAttackPlayer.new(
		HopInDirection.new(
			TOWARDS_PLAYER, active_chase_speed, active_chase_hops, active_rest_frames
		)
	)
	avoid_ocean_behavior = AvoidOcean.new(
		_rng_key("avoid_ocean"), active_chase_hops, inactive_avoid_speed
	)


func select_next_behavior() -> AnimalBehavior:
	if activation_criteria.is_matched_by(self):
		return active_behavior
	return inactive_behavior
