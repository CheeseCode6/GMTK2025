extends Node2D
@export var next_level:String
@onready var sound: AudioStreamPlayer2D = $sound

func _on_area_2d_body_entered(body: Node2D) -> void:
	sound.play()
	call_deferred("_change_scene")

func _change_scene() -> void:
	get_tree().change_scene_to_file(next_level)
