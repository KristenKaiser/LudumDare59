@tool
extends Node2D
class_name Obstical

@export var x_size : int = 1
@export var y_size : int = 1
@export var sprite2d : Sprite2D
#@export var sprite_texture : Texture2D
@export var start_rotation_steps : int 
var rotation_offset : int = 0
@export var rotation_step : int = 45
@export var rotate_buttons : HBoxContainer
#@export var collision_shape : Area2D

func _process(_delta):
	if Engine.is_editor_hint():
		if sprite2d: 
			sprite2d.rotation_degrees = rotation_step * start_rotation_steps

func _ready() -> void:
	#sprite2d.texture = sprite_texture
	call_deferred("set_button_size")
	rotate_object(rotation_step * start_rotation_steps)

func set_button_size():
	rotate_buttons.size = sprite2d.texture.get_size() * sprite2d.scale
	rotate_buttons.global_position = sprite2d.global_position

func set_sprite_position():
	sprite2d.position = Vector2(Global.grid.cell_size/2.0, Global.grid.cell_size/2.0)

func rotate_right():
	rotate_object(rotation_step)

func rotate_left():
	rotate_object(-rotation_step)

func rotate_object(degrees : int):
	sprite2d.rotation_degrees += degrees

func _on_left_button_down() -> void:
	rotate_left()

func _on_right_button_down() -> void:
	rotate_right()
