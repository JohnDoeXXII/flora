extends Node

## Emitted only when the phase changes.
signal time_changed(phase: DayPhase.Phase)

## Total real-world seconds for one full day/night cycle.
const DAY_DURATION: float = 20.0

## Threshold boundaries (fraction of cycle) for each phase.
const THRESHOLDS: Array[float] = [0.0, 0.25, 0.5, 0.75]

var _time: float = 0.0
var current_phase: DayPhase.Phase = DayPhase.Phase.DAWN


func _process(delta: float) -> void:
	_time = fmod(_time + delta / DAY_DURATION, 1.0)
	var new_phase := _phase_for(_time)
	if new_phase != current_phase:
		current_phase = new_phase
		time_changed.emit(current_phase)


func _phase_for(t: float) -> DayPhase.Phase:
	if t < THRESHOLDS[1]:
		return DayPhase.Phase.DAWN
	elif t < THRESHOLDS[2]:
		return DayPhase.Phase.DAY
	elif t < THRESHOLDS[3]:
		return DayPhase.Phase.DUSK
	else:
		return DayPhase.Phase.NIGHT
