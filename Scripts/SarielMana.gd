class_name Mana


extends Node

signal max_mana_changed(diff: int)
signal mana_changed(diff: int)
signal mana_depleted

@export var max_mana: int = 5 : set = set_max_mana, get = get_max_mana
@onready var mana: int = max_mana : set = set_mana, get = get_mana


func set_max_mana(value: int):
	var clamped_value = max(1, value)
	
	if clamped_value != max_mana:
		var difference = clamped_value - max_mana
		max_mana = clamped_value
		max_mana_changed.emit(difference)
		
		if mana > max_mana:
			set_mana(max_mana)

func get_max_mana() -> int:
	return max_mana

func set_mana(value: int):
	if value < mana:
		return
	
	var new_mana = clampi(value, 0, max_mana)
	
	if new_mana != mana:
		var difference = new_mana - mana
		mana = new_mana
		mana_changed.emit(difference)

		if mana <= 0:
			mana_depleted.emit()

func get_mana() -> int:
	return mana
	
func reset_mana():
	mana = max_mana
	mana_changed.emit(0) 
