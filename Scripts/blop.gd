extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var edge_check = $CollisionShape2D2/RayCast2D

var speed = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if player:
		var direction = global_position.direction_to(player.global_position)
		
		edge_check.position.x = sign(direction.x) * 20
		
		if edge_check.is_colliding() and is_on_floor():
			velocity.x = direction.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if velocity.x != 0:
			sprite.flip_h = velocity.x > 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
