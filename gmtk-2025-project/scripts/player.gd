#player.gd
extends CharacterBody2D

@onready var jump_buffer: Timer = $jump_buffer
@onready var coyote_time: Timer = $coyote_time

const SPEED = 150
const JUMP_VELOCITY = -300
const jumping_gravity = 1700
const falling_gravity = 2400
const accelaration = 80
const def_decel = 80

var spawn_pos:Vector2
var decel = def_decel
var buffered = false
var coyoted = false
var was_on_floor = true
var last_block:Node2D = null

func _ready() -> void:
	spawn_pos = position

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
	
func place_block()->void:
	if last_block:
		last_block.queue_free()
		last_block.visible = false
	var block = preload("res://scenes/dead_blok.tscn").instantiate()
	block.position.x = position.x
	block.position.y = position.y
	get_parent().call_deferred("add_child", block)
	last_block = block
	
func respawn():
	position = spawn_pos
	velocity = Vector2.ZERO
