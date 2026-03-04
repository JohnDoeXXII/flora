class_name Bed
extends Interactable


func get_prompt() -> String:
	return "Sleep"


func interact(initiator: Node2D) -> void:
	await ScreenFade.fade_out()
	DayNightCycle.skip_to_phase(DayPhase.Phase.DAWN)
	await ScreenFade.fade_in()
