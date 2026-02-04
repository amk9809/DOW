extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var is_in_range: bool = false
var target_object: Node2D
 
@onready var OJ = $Overworld_jump
@onready var UJ = $Underworld_jump
@onready var os = $Overworld_steps
@onready var US = $Underworld_steps
@onready var D = $Dash
@onready var marker_2d: Marker2D = $Marker2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
