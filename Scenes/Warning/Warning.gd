extends Control

class_name Warning
@onready var timer: Timer = $Timer


var _is_countdown: bool = false
@onready var label: Label = $VBoxContainer/Label

func _enter_tree() -> void:
	Signals.on_rock_getting_lost.connect(on_rock_getting_lost)
	
func _process(delta: float) -> void:
	pass
	
func on_rock_getting_lost(lost:bool): 
	if lost: 
		show()
		timer.start()
		#Signals.emit_on_rock_getting_lost(false)
		print(timer.wait_time)
	else: 
		hide()
		
func _on_timer_timeout() -> void:
	label.text = "Rock Lost..."
	Signals.emit_on_game_over()
