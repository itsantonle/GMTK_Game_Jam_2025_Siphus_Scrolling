extends Trigger

@onready var timer: Timer = $Timer

var _has_syphus: bool = false
var _has_rock: bool = false 
func _on_body_entered(body: Node2D) -> void:
	if body is Syphus:
		if ! _has_syphus:
			_has_syphus = true 
	if body is Rock: 
		if !_has_rock: 
			_has_rock = true 
	if _has_rock and _has_syphus: 
		Signals.emit_on_progress_game()
		Signals.emit_on_rock_getting_lost(false)
	
	else: 
		timer.start()

	


func _on_timer_timeout() -> void:
	if (_has_rock and !_has_syphus) or (!_has_rock and _has_syphus): 
		Signals.emit_on_rock_getting_lost(true)
		timer.stop()
