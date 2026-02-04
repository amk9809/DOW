extends CharacterBody2D


class_name PlatformerController2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var player_last_position: Vector2 = Vector2.ZERO

@export var README: String = "IMPORTANT: MAKE SURE TO ASSIGN 'left' 'right' 'jump' 'dash' 'up' 'down' in the project settings input map. Usage tips. 1. Hover over each toggle and variable to read what it does and to make sure nothing bugs. 2. Animations are very primitive. To make full use of your custom art, you may want to slightly change the code for the animations"
#INFO READEME 
#IMPORTANT: MAKE SURE TO ASSIGN 'left' 'right' 'jump' 'dash' 'up' 'down' in the project settings input map. THIS IS REQUIRED
#Usage tips. 
#1. Hover over each toggle and variable to read what it does and to make sure nothing bugs. 
#2. Animations are very primitive. To make full use of your custom art, you may want to slightly change the code for the animations
@onready var OJ = $Sounds/Overworld_jump
@onready var UJ = $Sounds/Underworld_jump
@onready var Os = $Sounds/Overworld_steps
@onready var US = $Sounds/Underworld_steps
@onready var D = $Sounds/Dash
@export_category("Necesary Child Nodes")
@export var PlayerSprite: AnimatedSprite2D
@export var PlayerCollider: CollisionShape2D

#INFO HORIZONTAL MOVEMENT 
@export_category("L/R Movement")
##The max speed your player will move
@export_range(50, 2000) var maxSpeed: float = 1200.0
##How fast your player will reach max speed from rest (in seconds)
@export_range(0, 4) var timeToReachMaxSpeed: float = 0.25
##How fast your player will reach zero speed from max speed (in seconds)
@export_range(0, 4) var timeToReachZeroSpeed: float = 0.25
##If true, player will instantly move and switch directions. Overrides the "timeToReach" variables, setting them to 0.
@export var directionalSnap: bool = false
##If enabled, the default movement speed will by 1/2 of the maxSpeed and the player must hold a "run" button to accelerate to max speed. Assign "run" (case sensitive) in the project input settings.
@export var runningModifier: bool = false

#INFO JUMPING 
@export_category("Jumping and Gravity")

##The peak height of your player's jumpaaa
@export_range(0, 20) var jumpHeight: float =2

##How many jumps your character can do before needing to touch the ground again. Giving more than 1 jump disables jump buffering and coyote time.
@export_range(0, 4) var jumps: int = 1

##The strength at which your character will be pulled to the ground.
@export_range(0, 100000) var gravityScale: float = 200.0

##The fastest your player can fall
@export_range(0, 200000) var terminalVelocity: float = 5000.0

##Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 30) var descendingGravityFactor: float = 1.5

##Enabling this toggle makes it so that when the player releases the jump key while still ascending, their vertical velocity will cut in half, providing variable jump height.
@export var shortHopAkaVariableJumpHeight: bool = true

##How much extra time (in seconds) your player will be given to jump after falling off an edge. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var coyoteTime: float = 0

##The window of time (in seconds) that your player can press the jump button before hitting the ground and still have their input registered as a jump. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var jumpBuffering: float = 0.2

#INFO EXTRAS
@export_category("Wall Jumping")
##Allows your player to jump off of walls. Without a Wall Kick Angle, the player will be able to scale the wall.
@export var wallJump: bool = true
##How long the player's movement input will be ignored after wall jumping.
@export_range(0, 0.5) var inputPauseAfterWallJump: float = 0.05
##The angle at which your player will jump away from the wall. 0 is straight away from the wall, 90 is straight up. Does not account for gravity
@export_range(0, 90) var wallKickAngle: float = 75.0
##The player's gravity will be divided by this number when touch a wall and descending. Set to 1 by default meaning no change will be made to the gravity and there is effectively no wall sliding. THIS IS OVERRIDDED BY WALL LATCH.
@export_range(1, 20) var wallSliding: float = 1
##If enabled, the player's gravity will be set to 0 when touching a wall and descending. THIS WILL OVERRIDE WALLSLIDING.
@export var wallLatching: bool = false
##wall latching must be enabled for this to work. #If enabled, the player must hold down the "latch" key to wall latch. Assign "latch" in the project input settings. The player's input will be ignored when latching.
@export var wallLatchingModifer: bool = false
@export_category("Dashing")
##The type of dashes the player can do.
@export_enum("None", "Horizontal", "Vertical", "Four Way", "Eight Way") var dashType: int =1
##How many dashes your player can do before needing to hit the ground.
@export_range(0, 10) var dashes: int = 1
##If enabled, pressing the opposite direction of a dash, during a dash, will zero the player's velocity.
@export var dashCancel: bool = true
##How far the player will dash. One of the dashing toggles must be on for this to be used.
@export_range(1.5, 4) var dashLength: float = 4
@export_category("Corner Cutting/Jump Correct")
##If the player's head is blocked by a jump but only by a little, the player will be nudged in the right direction and their jump will execute as intended. NEEDS RAYCASTS TO BE ATTACHED TO THE PLAYER NODE. AND ASSIGNED TO MOUNTING RAYCAST. DISTANCE OF MOUNTING DETERMINED BY PLACEMENT OF RAYCAST.
@export var cornerCutting: bool = false
##How many pixels the player will be pushed (per frame) if corner cutting is needed to correct a jump.
@export_range(1, 5) var correctionAmount: float = 1.5
##Raycast used for corner cutting calculations. Place above and to the left of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var leftRaycast: RayCast2D
##Raycast used for corner cutting calculations. Place above of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var middleRaycast: RayCast2D
##Raycast used for corner cutting calculations. Place above and to the right of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var rightRaycast: RayCast2D
@export_category("Down Input")
##Holding down will crouch the player. Crouching script may need to be changed depending on how your player's size proportions are. It is built for 32x player's sprites.
@export var crouch: bool = false
##Holding down and pressing the input for "roll" will execute a roll if the player is grounded. Assign a "roll" input in project settings input.
@export var canRoll: bool
@export_range(1.25, 2) var rollLength: float = 2
##If enabled, the player will stop all horizontal movement midair, wait (groundPoundPause) seconds, and then slam down into the ground when down is pressed. 
@export var groundPound: bool
##The amount of time the player will hover in the air before completing a ground pound (in seconds)
@export_range(0.05, 0.75) var groundPoundPause: float = 0.25
##If enabled, pressing up will end the ground pound early
@export var upToCancel: bool = false

@export_category("Animations (Check Box if has animation)")
##Animations must be named "run" all lowercase as the check box says
@export var run: bool
##Animations must be named "jump" all lowercase as the check box says
@export var jump: bool
##Animations must be named "idle" all lowercase as the check box says
@export var idle: bool
##Animations must be named "walk" all lowercase as the check box says
@export var walk: bool
##Animations must be named "slide" all lowercase as the check box says
@export var slide: bool
##Animations must be named "latch" all lowercase as the check box says
@export var latch: bool
##Animations must be named "falling" all lowercase as the check box says
@export var falling: bool
##Animations must be named "crouch_idle" all lowercase as the check box says
@export var crouch_idle: bool
##Animations must be named "crouch_walk" all lowercase as the check box says
@export var crouch_walk: bool
##Animations must be named "roll" all lowercase as the check box says
@export var roll: bool



#Variables determined by the developer set ones.
var swap
var appliedGravity: float
var maxSpeedLock: float
var appliedTerminalVelocity: float

var friction: float
var acceleration: float
var deceleration: float
var instantAccel: bool = false
var instantStop: bool = false

var jumpMagnitude: float = 500.0
var jumpCount: int=1
var jumpWasPressed: bool = false
var coyoteActive: bool = false
var dashMagnitude: float
var gravityActive: bool = true
var dashing: bool = false
var dashCount: int=1
var rolling: bool = false

var twoWayDashHorizontal
var twoWayDashVertical
var eightWayDash

var wasMovingR: bool
var wasPressingR: bool
var movementInputMonitoring: Vector2 = Vector2(true, true) #movementInputMonitoring.x addresses right direction while .y addresses left direction

var gdelta: float = 1

var dset = false

var colliderScaleLockY
var colliderPosLockY

var latched
var wasLatched
var crouching
var groundPounding

var anim
var col
var animScaleLock : Vector2

#Input Variables for the whole script
var upHold
var downHold
var leftHold
var leftTap
var leftRelease
var rightHold
var rightTap
var rightRelease
var jumpTap
var jumpRelease
var runHold
var latchHold
var dashTap
var rollTap
var downTap
var twirlTap

var is_knocked_back: bool = false

var hearts_anims: Array[AnimatedSprite2D]

var q_index: int = 0

func _updateData():
	acceleration = maxSpeed / timeToReachMaxSpeed
	deceleration = -maxSpeed / timeToReachZeroSpeed
	
	jumpMagnitude = (10.0 * jumpHeight) * gravityScale
	jumpCount = jumps
	
	dashMagnitude = maxSpeed * dashLength
	dashCount = dashes
	
	maxSpeedLock = maxSpeed
	
	#animScaleLock = abs(anim.scale)
	#colliderScaleLockY = col.scale.y
	#colliderPosLockY = col.position.y
	
	if timeToReachMaxSpeed == 0:
		instantAccel = true
		timeToReachMaxSpeed = 1
	elif timeToReachMaxSpeed < 0:
		timeToReachMaxSpeed = abs(timeToReachMaxSpeed)
		instantAccel = false
	else:
		instantAccel = false
		
	if timeToReachZeroSpeed == 0:
		instantStop = true
		timeToReachZeroSpeed = 1
	elif timeToReachMaxSpeed < 0:
		timeToReachMaxSpeed = abs(timeToReachMaxSpeed)
		instantStop = false
	else:
		instantStop = false
		
	if jumps > 1:
		jumpBuffering = 0
		coyoteTime = 0
	
	coyoteTime = abs(coyoteTime)
	jumpBuffering = abs(jumpBuffering)
	
	if directionalSnap:
		instantAccel = true
		instantStop = true
	
	
	twoWayDashHorizontal = false
	twoWayDashVertical = false
	eightWayDash = false
	if dashType == 0:
		pass
	if dashType == 1:
		twoWayDashHorizontal = true
	elif dashType == 2:
		twoWayDashVertical = true
	elif dashType == 3:
		twoWayDashHorizontal = true
		twoWayDashVertical = true
	elif dashType == 4:
		eightWayDash = true

func _input(event):
	event = "Heal Abillity"
	if Input.is_action_just_pressed(event):
		var heart_index = SarielHealth.health
		var mana_index = SarielMana.mana - 1
		if mana_index>0 and heart_index<6:
			SarielHealth.set_health(heart_index+1)
			print("a")
		else:
			pass

func _process(delta):
	pass
		#if Input.is_action_pressed("charge"):
			#_hold_duration += delta # Accumulate time
		# Check if the accumulated time exceeds the threshold
			#if _hold_duration >= HOLD_TIME_THRESHOLD:
		#		pass
		#else
		#	_hold_duration = 0.0
		# Optional: Reset the long-press flag here as well
		

func _physics_process(delta):
		#INFO animations
	#directions

	#if rightHold and !latched:
		#anim.scale.x = animScaleLock.x
	#if leftHold and !latched:
		#anim.scale.x = animScaleLock.x * -1
	if is_knocked_back:
		# Dok je u knockbacku, samo primenjuj gravitaciju i pomeraj je
		velocity.y += appliedGravity * delta
		move_and_slide()
		return
	
	var current_scene_node = get_tree().get_current_scene()
	var scene_path_string = current_scene_node.scene_file_path
	
	if scene_path_string == "res://Hackaton-main/Scenes/underworld.tscn":
		if !dashing:
			#if jumpTap:
				#animated_sprite.play("jchargeD")
			if velocity.y<0:
				animated_sprite.play("jumpD")
				UJ.play()
			
			if abs(velocity.x) > 0.1 and is_on_floor():
				if abs(velocity.x) < (maxSpeedLock):
					animated_sprite.play("walkD")
					US.play()
				else:
					animated_sprite.play("runD")
					
			elif abs(velocity.x)==0 and is_on_floor():
				animated_sprite.play("idleD")
		
		if velocity.y > 40 and !dashing:
			animated_sprite.play("fallD")
			
		if dashing:
			animated_sprite.play("dashD")
			

	else:
		if !dashing:
			if abs(velocity.x) > 0.1 and is_on_floor():
				if abs(velocity.x) < (maxSpeedLock):
					animated_sprite.play("walkL")
					Os.play()
				else:
					animated_sprite.play("runL")
					
			elif abs(velocity.x)==0 and is_on_floor():
				animated_sprite.play("idleL")
		
		if velocity.y<0:
			animated_sprite.play("jumpL")
			OJ.play()
		
		if velocity.y > 40 and !dashing:
			animated_sprite.play("fallL")
			
		if dashing:
			animated_sprite.play("dashL")
			
			
			
		#run
	
	if !dset:
		gdelta = delta
		dset = true
	#INFO Input Detectio. Define your inputs from the project settings here.
	leftHold = Input.is_action_pressed("left")
	rightHold = Input.is_action_pressed("right")
	upHold = Input.is_action_pressed("up")
	downHold = Input.is_action_pressed("down")
	leftTap = Input.is_action_just_pressed("left")
	rightTap = Input.is_action_just_pressed("right")
	leftRelease = Input.is_action_just_released("left")
	rightRelease = Input.is_action_just_released("right")
	jumpTap = Input.is_action_just_pressed("jump")
	jumpRelease = Input.is_action_just_released("jump")
	#runHold = Input.is_action_pressed("run")
	#latchHold = Input.is_action_pressed("latch")
	dashTap = Input.is_action_just_pressed("dash")
	#rollTap = Input.is_action_just_pressed("roll")
	downTap = Input.is_action_just_pressed("down")
	#twirlTap = Input.is_action_just_pressed("twirl")
	swap=Input.is_action_just_pressed("Switch")
	
	
	#INFO Left and Right Movement
	
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true
		
		
	
	if swap:
		var path = get_tree().current_scene.scene_file_path
		if path == "res://Hackaton-main/Scenes/overworld.tscn" or path == "res://Hackaton-main/Scenes/underworld.tscn":
		# Koristimo call_deferred da bismo bili sigurni da se promena desi 
		# tek kada se završe sve trenutne kalkulacije fizike
			_swap.call_deferred()
		return
	
	if rightHold and leftHold and movementInputMonitoring:
		if !instantStop:
			_decelerate(delta, false)
		else:
			velocity.x = -0.1
	elif rightHold and movementInputMonitoring.x:
		if velocity.x > maxSpeed or instantAccel:
			velocity.x = maxSpeed
		else:
			velocity.x += acceleration * delta
		if velocity.x < 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				velocity.x = -0.1
	elif leftHold and movementInputMonitoring.y:
		if velocity.x < -maxSpeed or instantAccel:
			velocity.x = -maxSpeed
		else:
			velocity.x -= acceleration * delta
		if velocity.x > 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				velocity.x = 0.1
				
	if velocity.x > 0:
		wasMovingR = true
	elif velocity.x < 0:
		wasMovingR = false
		
	if rightTap:
		wasPressingR = true
	if leftTap:
		wasPressingR = false
	
	if runningModifier and !runHold:
		maxSpeed = maxSpeedLock / 2
	elif is_on_floor():
		maxSpeed = maxSpeedLock
	
	if !(leftHold or rightHold):
		if !instantStop:
			_decelerate(delta, false)
		else:
			velocity.x = 0
			
	#INFO Crouching
	if crouch:
		if downHold and is_on_floor():
			crouching = true
		elif !downHold and ((runHold and runningModifier) or !runningModifier) and !rolling:
			crouching = false
			
	if !is_on_floor():
		crouching = false
			
	if crouching:
		maxSpeed = maxSpeedLock / 2
		col.scale.y = colliderScaleLockY / 2
		col.position.y = colliderPosLockY + (8 * colliderScaleLockY)
	else:
		maxSpeed = maxSpeedLock
		#col.scale.y = colliderScaleLockY
		#col.position.y = colliderPosLockY
		
	#INFO Rolling
	if canRoll and is_on_floor() and rollTap and crouching:
		_rollingTime(0.75)
		if wasPressingR and !(upHold):
			velocity.y = 0
			velocity.x = maxSpeedLock * rollLength
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(rollLength * 0.0625)
		elif !(upHold):
			velocity.y = 0
			velocity.x = -maxSpeedLock * rollLength
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(rollLength * 0.0625)
		
	if canRoll and rolling:
		#if you want your player to become immune or do something else while rolling, add that here.
		pass
			
	#INFO Jump and Gravity
	if velocity.y > 0:
		appliedGravity = gravityScale * descendingGravityFactor
	else:
		appliedGravity = gravityScale
	
	if is_on_wall() and !groundPounding:
		appliedTerminalVelocity = terminalVelocity / wallSliding
		if wallLatching and ((wallLatchingModifer and latchHold) or !wallLatchingModifer):
			appliedGravity = 0
			
			if velocity.y < 0:
				velocity.y += 50
			if velocity.y > 0:
				velocity.y = 0
				
			if wallLatchingModifer and latchHold and movementInputMonitoring == Vector2(true, true):
				velocity.x = 0
			
		elif wallSliding != 1 and velocity.y > 0:
			appliedGravity = appliedGravity / wallSliding
	elif !is_on_wall() and !groundPounding:
		appliedTerminalVelocity = terminalVelocity
	
	if gravityActive:
		if velocity.y < appliedTerminalVelocity:
			velocity.y += appliedGravity
		elif velocity.y > appliedTerminalVelocity:
				velocity.y = appliedTerminalVelocity
		
	if shortHopAkaVariableJumpHeight and jumpRelease and velocity.y < 0:
		velocity.y = velocity.y / 2
	
	if jumps == 1:
		if !is_on_floor() and !is_on_wall():
			if coyoteTime > 0:
				coyoteActive = true
				_coyoteTime()
				
		if jumpTap and !is_on_wall():
			if coyoteActive:
				coyoteActive = false
				_jump()
			if jumpBuffering > 0:
				jumpWasPressed = true
				_bufferJump()
			elif jumpBuffering == 0 and coyoteTime == 0 and is_on_floor():
				_jump()	
		elif jumpTap and is_on_wall() and !is_on_floor():
			if wallJump and !latched:
				_wallJump()
			elif wallJump and latched:
				_wallJump()
		elif jumpTap and is_on_floor():
			_jump()
		
		
			
		if is_on_floor():
			jumpCount = jumps
			coyoteActive = true
			if jumpWasPressed:
				_jump()

	elif jumps > 1:
		if is_on_floor():
			jumpCount = jumps
		if jumpTap and jumpCount > 0 and !is_on_wall():
			velocity.y = -jumpMagnitude
			jumpCount = jumpCount - 1
			_endGroundPound()
		elif jumpTap and is_on_wall() and wallJump:
			_wallJump()
			
			
	#INFO dashing
	if is_on_floor():
		dashCount = dashes
	if eightWayDash and dashTap and dashCount > 0 and !rolling:
		var input_direction = Input.get_vector("left", "right", "up", "down")
		
		var dTime = 0.0625 * dashLength
		_dashingTime(dTime)
		_pauseGravity(dTime)
		velocity = dashMagnitude * input_direction
		dashCount += -1
		movementInputMonitoring = Vector2(false, false)
		_inputPauseReset(dTime)
	
	if twoWayDashVertical and dashTap and dashCount > 0 and !rolling:
		var dTime = 0.0625 * dashLength
		if upHold and downHold:
			_placeHolder()
		elif upHold:
			_dashingTime(dTime)
			_pauseGravity(dTime)
			velocity.x = 0
			velocity.y = -dashMagnitude
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(dTime)
		elif downHold and dashCount > 0:
			_dashingTime(dTime)
			_pauseGravity(dTime)
			velocity.x = 0
			velocity.y = dashMagnitude
			dashCount += -1
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(dTime)
	
	if twoWayDashHorizontal and dashTap and dashCount > 0 and !rolling:
		var dTime = 0.0625 * dashLength
		if wasPressingR and !(upHold or downHold):
			velocity.y = 0
			velocity.x = dashMagnitude
			_pauseGravity(dTime)
			_dashingTime(dTime)
			dashCount += -1
			D.play()
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(dTime)
		elif !(upHold or downHold):
			velocity.y = 0
			velocity.x = -dashMagnitude
			_pauseGravity(dTime)
			_dashingTime(dTime)
			dashCount += -1
			D.play()
			movementInputMonitoring = Vector2(false, false)
			_inputPauseReset(dTime)
			
	if dashing and velocity.x > 0 and leftTap and dashCancel:
		velocity.x = 0
	if dashing and velocity.x < 0 and rightTap and dashCancel:
		velocity.x = 0
	
	#INFO Corner Cutting
	if cornerCutting:
		if velocity.y < 0 and leftRaycast.is_colliding() and !rightRaycast.is_colliding() and !middleRaycast.is_colliding():
			position.x += correctionAmount
		if velocity.y < 0 and !leftRaycast.is_colliding() and rightRaycast.is_colliding() and !middleRaycast.is_colliding():
			position.x -= correctionAmount
			
	#INFO Ground Pound
	if groundPound and downTap and !is_on_floor() and !is_on_wall():
		groundPounding = true
		gravityActive = false
		velocity.y = 0
		await get_tree().create_timer(groundPoundPause).timeout
		_groundPound()
	if is_on_floor() and groundPounding:
		_endGroundPound()
	move_and_slide()
	
	if upToCancel and upHold and groundPound:
		_endGroundPound()

func _bufferJump():
	await get_tree().create_timer(jumpBuffering).timeout
	jumpWasPressed = false

func _coyoteTime():
	await get_tree().create_timer(coyoteTime).timeout
	coyoteActive = false
	jumpCount += -1	

	
func _jump():
	if jumpCount > 0:
		velocity.y = -jumpMagnitude
		jumpCount += -1
		jumpWasPressed = false
		
func _wallJump():
	var horizontalWallKick = abs(jumpMagnitude * cos(wallKickAngle * (PI / 180)))
	var verticalWallKick = abs(jumpMagnitude * sin(wallKickAngle * (PI / 180)))
	velocity.y = -verticalWallKick
	var dir = 1
	if wallLatchingModifer and latchHold:
		dir = -1
	if wasMovingR:
		velocity.x = -horizontalWallKick * dir
	else:
		velocity.x = horizontalWallKick * dir
	if inputPauseAfterWallJump != 0:
		movementInputMonitoring = Vector2(false, false)
		_inputPauseReset(inputPauseAfterWallJump)
			
func _setLatch(delay, setBool):
	await get_tree().create_timer(delay).timeout
	wasLatched = setBool
			
func _inputPauseReset(time):
	await get_tree().create_timer(time).timeout
	movementInputMonitoring = Vector2(true, true)
	

func _decelerate(delta, vertical):
	if !vertical:
		if velocity.x > 0:
			velocity.x += deceleration * delta
		elif velocity.x < 0:
			velocity.x -= deceleration * delta
	elif vertical and velocity.y > 0:
		velocity.y += deceleration * delta


func _pauseGravity(time):
	gravityActive = false
	await get_tree().create_timer(time).timeout
	gravityActive = true

func _dashingTime(time):
	dashing = true
	await get_tree().create_timer(time).timeout
	dashing = false

func _rollingTime(time):
	rolling = true
	await get_tree().create_timer(time).timeout
	rolling = false	

func _groundPound():
	appliedTerminalVelocity = terminalVelocity * 10
	velocity.y = jumpMagnitude * 2
	
func _endGroundPound():
	groundPounding = false
	appliedTerminalVelocity = terminalVelocity
	gravityActive = true

func _placeHolder():
	print("")


func _swap():
	var current_scene_node = get_tree().get_current_scene()
	var scene_path_string = current_scene_node.scene_file_path
	
	Pos.player_last_position = self.global_position
	
	if scene_path_string == "res://Hackaton-main/Scenes/underworld.tscn":
		get_tree().change_scene_to_file("res://Hackaton-main/Scenes/overworld.tscn")
	else:
		get_tree().change_scene_to_file("res://Hackaton-main/Scenes/underworld.tscn")
		
func take_damage():
	if SarielHealth.health > 0:
		var heart_index = SarielHealth.health - 1
		SarielHealth.health -= 1
		
		if heart_index >= 0 and heart_index < hearts_anims.size():
			_play_heart_break(heart_index)

func handle_death():
	print("Game Over animacija ili reset...")
	SarielHealth.reset_health()
	update_heart_display()

func _play_heart_break(index: int):
	var heart = hearts_anims[index]
	heart.play("breaking")
	
	await heart.animation_finished	
	if SarielHealth.health <= index:
		heart.play("empty")
		
func update_heart_display():
	for i in range(hearts_anims.size()):
		if i < SarielHealth.health:
			hearts_anims[i].play("full")
		else:
			hearts_anims[i].play("empty")

func _ready():
	ResourceLoader.load_threaded_request("res://Hackaton-main/Scenes/underworld.tscn")
	ResourceLoader.load_threaded_request("res://Hackaton-main/Scenes/overworld.tscn")
	add_to_group("players")
	var hearts_parent = $health_bar/HBoxContainer
	for heart_node in hearts_parent.get_children():
		var anim_sprite = heart_node.get_node_or_null("Heart")
		if anim_sprite:
			hearts_anims.append(anim_sprite)
			anim_sprite.play("full") # Postavi sve na početno stanje
	
	wasMovingR = true
	anim = PlayerSprite
	col = PlayerCollider
	_updateData()
	_input("Heal Abillity")
	
	self.global_position = Pos.player_last_position
	
	if !SarielHealth.health_depleted.is_connected(_on_sariel_death):
		SarielHealth.health_depleted.connect(_on_sariel_death)
	
	update_heart_display()

# I onda napraviš funkciju koja se izvršava kad umre
func _on_sariel_death():
	print("Sariel je ostala bez svih srca!")
	
	# Proveravamo da li prvo srce postoji i da li još uvek igra animaciju
	if hearts_anims.size() > 0:
		var last_heart = hearts_anims[0]
		if last_heart.animation == "breaking":
			await last_heart.animation_finished
	
	# Dodajemo još mrvicu pauze (0.2s) da igrač "upije" prazan ekran pre reseta
	await get_tree().create_timer(0.6).timeout
	
	handle_death()

func apply_knockback(source_position: Vector2):
	if is_knocked_back: return # Da ne bi dobila dupli knockback
	
	is_knocked_back = true
	
	# Određujemo smer: ako je izvor (neprijatelj) desno od Sariel, ona leti levo (-1)
	var knock_dir = -1 if source_position.x > global_position.x else 1
	
	# Postavljamo silu (možeš menjati ove brojeve)
	velocity.x = knock_dir*2000# Jačina horizontalnog odskoka
	velocity.y = -600 # Skok uvis pri udarcu
	
	# Trajanje knockback-a (koliko dugo igrač nema kontrolu)
	await get_tree().create_timer(0.25).timeout
	is_knocked_back = false
