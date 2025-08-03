extends Trigger



var _rock_lost: bool = false 
func _enter_tree() -> void:
	Signals.on_rock_getting_lost.connect(on_rock_getting_lost)
	
func _on_body_entered(body: Node2D) -> void:
	
	if body is Rock: 
		_rock_lost = false 
		Signals.emit_on_rock_getting_lost(_rock_lost)

func _on_body_exited(body: Node2D) -> void:
	if body is Rock: 
		_rock_lost = true 
		
		Signals.emit_on_rock_getting_lost(_rock_lost)
		
func on_rock_getting_lost(lost: bool): 
	_rock_lost = lost
		
