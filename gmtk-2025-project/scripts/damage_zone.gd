#damagezone.gd
extends Area2D
@onready var death_wait: Timer = $death_wait
var plyr:Node2D

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		plyr = body
		body.place_block()
		die()
		
func die()->void:
	Engine.time_scale = 0.5
	death_wait.start()

func _on_death_wait_timeout() -> void:
	Engine.time_scale = 1
	plyr.respawn()
