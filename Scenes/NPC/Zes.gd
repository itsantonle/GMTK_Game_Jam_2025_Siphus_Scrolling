extends Area2D
class_name Zes
@onready var hand: StaticBody2D = $Hand

const THOUGHT = preload("res://Scenes/Thought/Thought.tscn")
const DIALOG: Array[String] = ["You won't go any further.", "Try as hard as you might... it's going to be the same thing again and again"]
@onready var thought_marker: Marker2D = $ThoughtMarker
const SY_THOUHTS: Array[String] = ["Ths won't end!", "Maybe I can try to push through?", "It's just a loop."]

func _ready() -> void:
	pass

func instantiate_thought_after_dialog(dialog: Array[String]) -> void: 
	var thought_container: Thought = THOUGHT.instantiate()
	add_child(thought_container)
	thought_container.setup(dialog)
	thought_container.global_position = thought_marker.global_position
	thought_container.scale = Vector2(1,1)
	thought_container.set_char_name("HIM")
	
func _on_body_entered(body: Node2D) -> void:
	instantiate_thought_after_dialog(DIALOG)
	if body is Syphus: 
		body._set_thoughts(SY_THOUHTS)
	


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
