extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Rock: 
		Signals.emit_on_rock_off_screen()
