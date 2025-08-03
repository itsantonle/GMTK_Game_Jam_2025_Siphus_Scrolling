extends RigidBody2D

class_name Rock
const ROCK_GROUP = "rock_group"
# Called when the node enters the scene tree for the first time.
var _is_on_screen: bool = true 
@onready var sound: AudioStreamPlayer2D = $sound

var _threshold: float = 0.5

	
func _ready() -> void:
	add_to_group(ROCK_GROUP)
	 # Replace with function body.

func _physics_process(delta: float) -> void:
	if linear_velocity.length() > _threshold and not sound.playing:
		sound.play()
		
	   



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:

	print('rock exit')
