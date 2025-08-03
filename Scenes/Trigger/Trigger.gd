extends Area2D
class_name Trigger


func _on_area_entered(area: Area2D) -> void:
	print("Trigger area", area)


func _on_body_entered(body: Node2D) -> void:
	print("Trigger body", body)


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
