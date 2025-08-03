extends Area2D
class_name NPC


@export var correct_choice: String = "y"  # 'y' is the correct answer in this case
@export var willingness_change: int = 20
@export var npc_name: String = "Tutorial Guy"

@export var dialog_lines: Array[String] = [
	"Siphus, it's been a long journey, hasn’t it?",
	"The rock never gets lighter, but something drives you forward.",
	"Do you still believe this matters?"
]

@export var wrong_thoughts: Array[String] = [
	"Maybe I should’ve said the other thing...",
	"Not sure that was the right call.",
	"Ugh. That felt... off."
]
@export var right_thoughts: Array[String] = [
	"I think he was right... I should really think about this more",
	"Make the right choice.."
]
@export var ball_getting_away: Array[String] = [
	"The ball is running from you again!"
]

@onready var thought_marker: Marker2D = $ThoughtMarker
@onready var exclaimation: Label = $Exclaimation
const THOUGHT = preload("res://Scenes/Thought/Thought.tscn")
const NPC_GROUP = "npc_group"


var _exclaimation_visible = false 
var _has_talked_already = false

func _ready() -> void:
	
	add_to_group(NPC_GROUP)
	
func play_animation() -> void:
	pass
	

func get_npc_name() -> String:
	return npc_name

	
func get_willingness_add() -> int: 
	return willingness_change
	
func get_npc_dialog() -> Array[String]: 
	return dialog_lines

func get_npc_wrong_thoughts() -> Array[String]: 
	return wrong_thoughts

func get_npc_right_thoughts() -> Array[String]: 
	return right_thoughts
	
func on_dialog_finished() -> bool: 
	return true
	
func toggle_exclamation(toggle: bool) -> void: 
	if toggle: 
		_exclaimation_visible = true
		exclaimation.show()
	else: 
		_exclaimation_visible = false
		exclaimation.hide()

func toggle_talked(toggle: bool) -> void: 
	_has_talked_already = toggle
	
func stop_thinking() -> void: 
	for child in get_children(): 
		if child is Thought: 
			child.toggle_in_use(false)
	
func resume_thinking() -> void: 
	for child in get_children(): 
		if child is Thought: 
			child.toggle_in_use(true)
			
func handle_syphus_answer(answer: String) -> void: 
	if answer == correct_choice: 
		instantiate_thought_after_dialog(right_thoughts)
	else: 
		instantiate_thought_after_dialog(wrong_thoughts)
	
func instantiate_thought_after_dialog(dialog: Array[String]) -> void: 
	var thought_container: Thought = THOUGHT.instantiate()
	add_child(thought_container)
	thought_container.setup(dialog)
	thought_container.global_position = thought_marker.global_position
	thought_container.scale = Vector2(0.5, 0.5)
	thought_container.set_char_name(npc_name)

	
	# signal to start dialog
	
func remove_npc() -> void: 
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if !_has_talked_already: 
		toggle_exclamation(true)
		
	
 
		


func _on_body_exited(body: Node2D) -> void:
	toggle_exclamation(false)
	
