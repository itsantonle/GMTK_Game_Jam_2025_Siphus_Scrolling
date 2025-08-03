extends Control


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("hard_push"): 
		GameManager.load_game()
