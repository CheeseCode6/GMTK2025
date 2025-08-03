#player.gd
extends CharacterBody2D

@onready var jump_buffer: Timer = $jump_buffer
@onready var coyote_time: Timer = $coyote_time
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_wait: Timer = $death_wait
@onready var death_sound: AudioStreamPlayer2D = $death_sound

const SPEED = 150
const JUMP_VELOCITY = -300
const jumping_gravity = 1000
const falling_gravity = 2200
const accelaration = 80
const def_decel = 80

var dead = false
var spawn_pos:Vector2
var decel = def_decel
var buffered = false
var coyoted = false
var was_on_floor = true
var last_block:Node2D = null

func _ready() -> void:
	spawn_pos = position

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("die"):
		dead = true
		die()
	if not is_on_floor():
		if was_on_floor:
			coyoted = true
			coyote_time.start()
	
	if not dead:
		#gravity
		if velocity.y > 0:
			velocity.y += falling_gravity*delta
		else:
			velocity.y += jumping_gravity*delta
				
		#input
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
			animation.play("running")
			velocity.x = move_toward(velocity.x,SPEED*direction,accelaration)
			animation.flip_h = direction<0
		else:
			animation.play("idle")
			velocity.x = move_toward(velocity.x, 0, decel)
		move_and_slide()
	was_on_floor = is_on_floor()
	
func jump()->void:
	animation.play("idle")
	velocity.y = JUMP_VELOCITY
	buffered = false

func _on_jump_buffer_timeout() -> void:
	buffered = false

func _on_coyote_time_timeout() -> void:
	coyoted = false
	
func place_block()->void:
	#if last_block:
		#last_block.queue_free()
		#last_block.visible = false
	var block = preload("res://scenes/dead_blok.tscn").instantiate()
	var offset := Vector2(1, -16)
	block.global_position = global_position + offset
	get_parent().call_deferred("add_child", block)
	#last_block = block
	
func respawn():
	dead = false
	position = spawn_pos
	velocity = Vector2.ZERO

func die()->void:
	animation.play("death")
	death_sound.play()
	Engine.time_scale = 0.5
	death_wait.start()

func _on_death_wait_timeout() -> void:
	Engine.time_scale = 1
	place_block()
	respawn()
