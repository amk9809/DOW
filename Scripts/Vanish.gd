extends Node2D

@onready var timer: Timer = $Timer
@onready var collision_shape: StaticBody2D = $StaticBody
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Sariel":
		timer.start()


func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self,"modulate:a",0,0.5)
	collision_shape.position= Vector2(-10000,200000)
