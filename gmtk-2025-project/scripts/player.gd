extends CharacterBody2D

@onready var jump_buffer: Timer = $jump_buffer
@onready var coyote_time: Timer = $coyote_time

const SPEED = 150
const JUMP_VELOCITY = -300
const jumping_gravity = 1700
const falling_gravity = 2400
const accelaration = 80
const def_decel = 80

var decel = def_decel
var buffered = false
var coyoted = false
var was_on_floor = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if was_on_floor:
			coyoted = true
			coyote_time.start()
		
		if velocity.y > 0:
			velocity.y += falling_gravity * delta
		else:
			velocity.y += jumping_gravity*delta

	if Input.is_action_pressed("jump"):
		if is_on_floor() or coyoted:
			if coyoted: print("coyote jump\n")
			jump()
		else:
			buffered = true
			jump_buffer.start()
	if is_on_floor() and buffered:
		jump()
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x,SPEED*direction,accelaration)
	else:
		velocity.x = move_toward(velocity.x, 0, decel)
		
	was_on_floor = is_on_floor()
	move_and_slide()

func jump()->void:
	velocity.y = JUMP_VELOCITY
	buffered = false

func _on_jump_buffer_timeout() -> void:
	buffered = false

func _on_coyote_time_timeout() -> void:
	coyoted = false
