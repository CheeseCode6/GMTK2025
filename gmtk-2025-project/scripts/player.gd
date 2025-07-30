extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const jumping_gravity = 1500
const falling_gravity = 3000
const accelaration = 40
const def_decel = 50

var decel = def_decel

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += falling_gravity * delta
		else:
			velocity.y += jumping_gravity*delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x,SPEED*direction,accelaration)
	else:
		velocity.x = move_toward(velocity.x, 0, decel)
		
	move_and_slide()
