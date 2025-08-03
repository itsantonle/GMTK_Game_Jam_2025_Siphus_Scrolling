extends CharacterBody2D
class_name Syphus


const GRUNT= preload("res://assets/Music/788782__mokeymokey__vo_grunt-2.mp3")
const PROMPT = preload("res://assets/Music/149347__setuniman__prompt-q46k.wav")

@export var move_speed :float= 200.0
@export var jump_impulse :float= -300.0
@export var gravity :float = 800.0
@export var push_force :float= 1800
@export var max_charge_time :float= 5.0
@export var max_push_force :float = 5000


@onready var will_label: Label = $will_label
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var thought: Thought = $Thought
const zero_willingness_thoughts: Array[String] =[
	"What am I even doing here?", 
	"This is tiring, I'll never get it done", 
	"Should've packed extra...too bad this is FOREVER."]
const panic_thoughts: Array[String] = [
	"The rock!",
	"Oh no!!!!!", 
	"After the rock!"
]

const SYPHUS_GROUP = "Syphus"
var _willingness :int = 100
var _thoughts : Array[String]= [
	"Struggling, struggling struggling to put this rock into place!",
	"Counting time and for what? It's a loop! For other people..",
	"Hardships make you tough-- ???",
	"This rock is heavy...",
	"Don't let the rock out of sight!"
]

@onready var sound: AudioStreamPlayer2D = $sound

var _is_charging_push : bool= false
var _charge_start_time : float = 0.0
var _pending_push :bool= false
var _rock_target: Rock = null
var _can_side_move: bool = true 
var _charge_duration: float = 0.5
var _npc_ref: NPC 
@onready var label: Label = $Label


func _enter_tree() -> void:
	Signals.on_rock_getting_lost.connect(on_rock_getting_lost)
	
	
func on_rock_getting_lost(lost:bool): 
	thought._thoughts = panic_thoughts
	
func _ready() -> void:
	
	add_to_group(SYPHUS_GROUP)
	_willingness = GameManager.willingness
	thought.setup(_thoughts)
	_rock_target = get_tree().get_first_node_in_group(Rock.ROCK_GROUP)
	if !_rock_target:
		print("No rock target found")
	_npc_ref = get_tree().get_first_node_in_group(NPC.NPC_GROUP)
	if !_npc_ref: 
		print(_npc_ref, "no npc ref")
		


func get_willingness() -> int: 
	return _willingness

func stop_thinking() -> void: 
	thought.toggle_in_use(false)

func resume_thinking() -> void: 
	thought.toggle_in_use(true)
	
func send_answer(answer: String) -> void: 
	pass
	
func _physics_process(delta: float) -> void:
	GameManager.willingness = _willingness
	Signals.emit_on_number_bar_change()
	
	give_up()
	start_dialog()
	_apply_gravity(delta)
	_handle_movement()
	#_handle_jump()
	_handle_push_input()
	move_and_slide()
	_update_label()
	_update_animation()
	_check_rock_collision()
	_process_pending_push()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		
func give_up() -> void: 
	if Input.is_action_pressed('restart'): 
		_willingness = 0
func _update_label() -> void: 
	label.text = 'williness: ' + str(_willingness) + '\nglobal: ' + str(GameManager.willingness)

func start_dialog() -> void:
	_npc_ref = GameManager._scene_npc
	if !GameManager._scene_npc: 
		print('no scene npc')
		return
	if GameManager._scene_npc._exclaimation_visible and !GameManager._scene_npc._has_talked_already: 

		if Input.is_action_pressed("Talk"): 
			sound.stop()
			sound.stream = PROMPT
			sound.play()
			var symbol: String = "+"
			_npc_ref.instantiate_thought_after_dialog(_npc_ref.dialog_lines)
			_npc_ref._has_talked_already = true
			_willingness += _npc_ref.willingness_change
			if _npc_ref.willingness_change < 0: 
				symbol = "-"
			will_label.text = symbol + str(_npc_ref.willingness_change)
			will_label.show()
			await get_tree().create_timer(2).timeout
			
			will_label.hide()
			
func _set_thoughts(thoughts: Array[String]) -> void: 
	thought._thoughts = thoughts
func _handle_movement() -> void:
	#if !is_on_floor(): 
		#return
	if _willingness <=30: 
		thought._thoughts = zero_willingness_thoughts
	if _willingness <= 0: 
		return 
		
	var direction := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction * move_speed
	if direction != 0 and !_is_charging_push and _willingness > 0:
		animated_sprite.flip_h = direction < 0

func _handle_jump() -> void:
	if Input.is_action_just_pressed("ui_up") and is_on_floor() and !_pending_push:
		velocity.y = jump_impulse
		


func _handle_push_input() -> void:
	if _willingness <= 0:
		animated_sprite.play("shake")  
		_is_charging_push = false
		_pending_push = false
		Signals.emit_on_syphus_no_will(false)
		
	
		return

	if Input.is_action_just_pressed("hard_push") and _rock_target:
		sound.stream = GRUNT
		sound.play()
			
		animated_sprite.play("push")  
		_is_charging_push = true
		_charge_start_time = Time.get_ticks_msec() / 1000.0
		Signals.emit_on_will_bar_change(_charge_duration)
		

	if Input.is_action_just_released("hard_push") and _is_charging_push:
		_is_charging_push = false
		_pending_push = true
		Signals.emit_on_will_bar_change(0.0)

		

func _update_animation() -> void:
	if _is_charging_push:
		animated_sprite.play("push")
			# emit signal to change will_bar width
		
		return
	

	if _willingness <= 0:
		animated_sprite.play("shake")
		return

	if velocity.x == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk")
		animated_sprite.flip_h = velocity.x < 0


func _check_rock_collision() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_collider() is Rock:
			_rock_target = collision.get_collider()
			var push_dir := velocity.normalized()
			collision.get_collider().apply_impulse(push_dir * push_force)
	

func _process_pending_push() -> void:
	if _pending_push and _rock_target and _willingness > 0:
		var now_time := Time.get_ticks_msec() / 1000.0
		var charge_duration :float= clamp(now_time - _charge_start_time, 0.0, max_charge_time)
		_charge_duration = charge_duration
		
		var push_strength :float= lerp(push_force, max_push_force, charge_duration / max_charge_time)

		push_strength *= float(_willingness) / 50.0  # weaken force when less willing
		var push_dir := (_rock_target.global_position - global_position).normalized()

		_rock_target.apply_impulse(push_dir * push_strength)


		_willingness = max(_willingness - int(charge_duration * 20.0), 0)
	_pending_push = false
	




func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('syphus out')
	Signals.emit_on_syphus_out_frame()
