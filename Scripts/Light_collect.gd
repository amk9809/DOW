extends Area2D

func _ready():
	# Ako je ovaj ključ već u listi, uništi ga odmah
	if Pos.collected_keys.has(self.name):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Sariel" :
		var tween = create_tween()
		
		tween.tween_property(self,"position",position+Vector2(-100000,-100000),0.3)
		
		Pos.collect_Lkey(position, self.name)
		
		tween.tween_callback(queue_free)
	
