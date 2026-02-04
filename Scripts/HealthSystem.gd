class_name EnemyHealth

extends Node

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted

@export var max_health: int = 5 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality

var immortality_timer: Timer = null


@onready var health: int = max_health : set = set_health, get = get_health


func set_max_health(value: int):
	var clamped_value = max(1, value)
	
	if clamped_value != max_health:
		var difference = clamped_value - max_health
		max_health = clamped_value
		max_health_changed.emit(difference)
		
		if health > max_health:
			set_health(max_health)

func get_max_health() -> int:
	return max_health


func set_immortality(value: bool):
	immortality = value

func get_immortality() -> bool:
	return immortality

func set_temporary_immortality(time: float):
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)
	
	if immortality_timer.timeout.is_connected(_on_immortality_timeout):
		immortality_timer.timeout.disconnect(_on_immortality_timeout)
	
	immortality_timer.set_wait_time(time)
	immortality_timer.timeout.connect(_on_immortality_timeout)
	
	self.immortality = true
	immortality_timer.start()

func _on_immortality_timeout():
	self.immortality = false


func set_health(value: int):
	if value < health and immortality:
		return
	
	var new_health = clampi(value, 0, max_health)
	
	if new_health != health:
		var difference = new_health - health
		health = new_health
		health_changed.emit(difference)

		if health <= 0:
			health_depleted.emit()

func get_health() -> int:
	return health
