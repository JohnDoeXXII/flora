extends Node

## Emitted only when the phase changes.
signal time_changed(phase: DayPhase.Phase)

## Total real-world seconds for one full day/night cycle.
const DAY_DURATION: float = 12.0

## Threshold boundaries (fraction of cycle) for each phase.
const THRESHOLDS: Array[float] = [0.0, 0.25, 0.5, 0.75]

## Ordered phase sequence used for cycle traversal.
const PHASE_ORDER: Array[DayPhase.Phase] = [
	DayPhase.Phase.DAWN,
	DayPhase.Phase.DAY,
	DayPhase.Phase.DUSK,
	DayPhase.Phase.NIGHT,
]

## Start-of-phase _time fractions, keyed by phase.
const PHASE_START_TIME: Dictionary = {
	DayPhase.Phase.DAWN:  0.0,
	DayPhase.Phase.DAY:   0.25,
	DayPhase.Phase.DUSK:  0.5,
	DayPhase.Phase.NIGHT: 0.75,
}

var _time: float = 0.0
var current_phase: DayPhase.Phase = DayPhase.Phase.DAWN


func _process(delta: float) -> void:
	_time = fmod(_time + delta / DAY_DURATION, 1.0)
	var new_phase := _phase_for(_time)
	if new_phase != current_phase:
		current_phase = new_phase
		time_changed.emit(current_phase)


## Advances time to [param target], emitting [signal time_changed] for every
## intermediate phase so that all listeners receive each transition in order.
func skip_to_phase(target: DayPhase.Phase) -> void:
	var start_idx: int = PHASE_ORDER.find(current_phase)
	var target_idx: int = PHASE_ORDER.find(target)
	var steps: int = (target_idx - start_idx + PHASE_ORDER.size()) % PHASE_ORDER.size()
	if steps == 0:
		steps = PHASE_ORDER.size()
	for i: int in range(1, steps + 1):
		var phase: DayPhase.Phase = PHASE_ORDER[(start_idx + i) % PHASE_ORDER.size()]
		current_phase = phase
		time_changed.emit(phase)
	_time = PHASE_START_TIME[target]


## Like [method skip_to_phase] but spreads the phase emissions evenly over
## [param duration] seconds, so callers can await the full animation.
func skip_to_phase_animated(target: DayPhase.Phase, duration: float) -> void:
	var start_idx: int = PHASE_ORDER.find(current_phase)
	var target_idx: int = PHASE_ORDER.find(target)
	var steps: int = (target_idx - start_idx + PHASE_ORDER.size()) % PHASE_ORDER.size()
	if steps == 0:
		steps = PHASE_ORDER.size()
	var interval: float = duration / steps
	for i: int in range(1, steps + 1):
		var phase: DayPhase.Phase = PHASE_ORDER[(start_idx + i) % PHASE_ORDER.size()]
		current_phase = phase
		time_changed.emit(phase)
		await get_tree().create_timer(interval).timeout
	_time = PHASE_START_TIME[target]


func _phase_for(t: float) -> DayPhase.Phase:
	if t < THRESHOLDS[1]:
		return DayPhase.Phase.DAWN
	elif t < THRESHOLDS[2]:
		return DayPhase.Phase.DAY
	elif t < THRESHOLDS[3]:
		return DayPhase.Phase.DUSK
	else:
		return DayPhase.Phase.NIGHT
