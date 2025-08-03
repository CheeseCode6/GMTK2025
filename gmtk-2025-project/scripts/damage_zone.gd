#damagezone.gd
extends Area2D
@onready var death_wait: Timer = $death_wait
@onready var death_sound: AudioStreamPlayer2D = $death_sound

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("in damage_zone")
		body.velocity = Vector2.ZERO
		body.dead = true
		body.die()
