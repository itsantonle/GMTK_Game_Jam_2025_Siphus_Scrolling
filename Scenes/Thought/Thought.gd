extends Control
class_name Thought

@onready var timer: Timer = $Timer
@onready var thought_label: Label = $VBoxContainer/ColorRect/ThoughtLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var name_label: Label = $VBoxContainer/ColorRect/Name
@onready var sound: AudioStreamPlayer2D = $sound
const NOTIFICATION = preload("res://assets/Music/242502__gabrielaraujo__pop-upnotification.wav")
var _thoughts: Array[String] = []
var _state: String = "appear"  
var _in_use: bool = true

func setup(thoughts: Array[String]) -> void: 
	if !_in_use: 
		hide()
		return
	if _in_use: 
		show()
		
	if !thoughts:
		_in_use = false 
		return
		
	_thoughts = thoughts
	pick_random_thought()
	timer.start()
	

func pick_random_thought() -> void:
	thought_label.text = _thoughts.pick_random()

func change_default_thought_time(seconds: int) -> void: 
	timer.wait_time = seconds

func toggle_in_use(used: bool) -> void: 
	_in_use = used
	if _in_use: 
		show()
	else: 
		hide()
	
func set_char_name(name: String) -> void: 
	name_label.text = name
	
	
func _on_timer_timeout() -> void:
	sound.global_position= global_position
	sound.stream = NOTIFICATION
	sound.play()
	if _in_use: 
		if _state == "appear":
			
			animation_player.play("disappear")
			await animation_player.animation_finished
			_state = "disappear"
		else:
			pick_random_thought()
			animation_player.play("appear")
			await animation_player.animation_finished
			_state = "appear"
