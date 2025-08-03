extends Control

class_name StatusUI


@onready var will_charge_bar: ChargeBar = $MarginContainer/HBoxContainer/VBoxContainer2/WilChargeBar
@onready var motivation: Label = $MarginContainer/HBoxContainer/VBoxContainer2/Motivation



func _enter_tree() -> void:
	Signals.on_will_bar_change.connect(on_will_bar_change)
	Signals.on_number_bar_change.connect(on_number_bar_change)
	
func _ready() -> void:
	if will_charge_bar: 
		print('charge bar ready')
		will_charge_bar.change_bar_width(0.0)
	if motivation: 
		motivation.text = str(GameManager.willingness) +"%"
	


func on_will_bar_change(percent: float) -> void:
	will_charge_bar.change_bar_width(percent)


func on_number_bar_change() -> void: 

	motivation.text=  str(GameManager.willingness) +"%"

	
