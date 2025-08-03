extends Control
class_name ChargeBar

@onready var texture_rect: TextureRect = $TextureRect
const PROGRESS = preload("res://assets/sprites/Progress.png")
var _texture_scale_x: float = 0 

const MAX_BAR_WIDTH: float = 0.3 



	
 
func change_bar_width(percent: float): 
	
	var target_scale: float = percent * MAX_BAR_WIDTH
	_texture_scale_x = target_scale
	
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(texture_rect, "scale:x", _texture_scale_x, 0.2)

	
