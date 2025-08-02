#damagezone.gd
extends Area2D
@onready var death_wait: Timer = $death_wait
@onready var death_sound: AudioStreamPlayer2D = $death_sound

var plyr:Node2D
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		plyr = body
		plyr.velocity = Vector2.ZERO
		plyr.dead = true
		die()

func die()->void:
	plyr.animation.play("death")
	death_sound.play()
	Engine.time_scale = 0.5
	death_wait.start()

func _on_death_wait_timeout() -> void:
	Engine.time_scale = 1
	plyr.place_block()
	plyr.respawn()
