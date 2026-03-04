class_name Bed
extends Interactable

const SLEEP_DURATION: float = 2.0


func get_prompt() -> String:
	return "Sleep"


func interact(initiator: Node2D) -> void:
	await ScreenFade.fade_out()
	await DayNightCycle.skip_to_phase_animated(DayPhase.Phase.DAWN, SLEEP_DURATION)
	await ScreenFade.fade_in()
