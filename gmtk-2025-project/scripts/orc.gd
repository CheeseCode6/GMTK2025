extends Node2D

@onready var ray_cast_right: RayCast2D = $raycast_right
@onready var ray_cast_left: RayCast2D = $raycast_left
@onready var ray_castbleft: RayCast2D = $raycast_bleft
@onready var ray_castbright: RayCast2D = $raycast_bright
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
var direction = 1
var speed = 50


func _process(delta: float) -> void:
	if ray_cast_right.is_colliding() or not ray_castbright.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
		
	if ray_cast_left.is_colliding() or not ray_castbleft.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += speed * delta * direction
	
