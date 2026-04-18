@tool
extends Node2D
class_name Grid

@export var grid_width : int = 10
@export var grid_height : int = 10
@export var obsticals : Node2D
var cell_size : int = 64
var grid_offset : Vector2 = Vector2.ZERO
@export var obstical_coords : Dictionary[Obstical, Vector2]

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()
		await get_tree().process_frame
		track_object_coords()

func _ready():
	Global.grid = self
	queue_redraw()
	await get_tree().process_frame
	center_obsticals()
	position = grid_offset

func _draw():
	# Draw grid 
	cell_size = get_cell_size()
	grid_offset = get_grid_offset()
	# Draw vertical lines
	for x in range(grid_width + 1):
		var start = Vector2((x * cell_size), 0)
		var end = Vector2((x * cell_size), grid_height * cell_size)
		draw_line(start, end, Color.WHITE, 1.0)

	# Draw horizontal lines
	for y in range(grid_height + 1):
		var start = Vector2(0, y * cell_size)
		var end = Vector2(grid_width * cell_size, y * cell_size)
		draw_line(start, end, Color.WHITE, 1.0)

func get_cell_size()-> int: 
	var viewport_size = get_viewport().size
	var x_max_cell_size = viewport_size.x / grid_width
	var y_max_cell_size = viewport_size.y / grid_height
	if x_max_cell_size < y_max_cell_size: 
		return x_max_cell_size
	else: 
		return y_max_cell_size

func get_grid_offset()-> Vector2: 
	var viewport_size : Vector2 = get_viewport().size
	var x_grid_size : int = grid_width * cell_size
	var y_grid_size : int = grid_height * cell_size
	var x_offset : int = floor((viewport_size.x -x_grid_size) / 2)
	var y_offset : int = floor((viewport_size.y -y_grid_size) / 2)
	return Vector2(x_offset, y_offset)

func center_obsticals(): 
	for obstical in obstical_coords: 
		obstical.scale =  Vector2(cell_size - 2, cell_size - 2) / obstical.sprite2d.texture.get_size()
		obstical.position = get_centered_position(obstical_coords[obstical], obstical.x_size, obstical.y_size)
		obstical.set_sprite_position()

func get_centered_position(obj_coords: Vector2, x_size : int , y_size : int )-> Vector2i:
	# get top right position of cell
	var x_position : int = floor(obj_coords.x * cell_size)
	var y_position : int = floor(obj_coords.y * cell_size)
	
	if x_size % 2 == 0:
		x_position += floor(cell_size/2.0)
	if y_size % 2 == 0:
		y_position += floor(cell_size/2.0)
	return Vector2(x_position  , y_position)


#func get_centered_position(obj_position : Vector2, x_size : int , y_size : int )-> Vector2i:
	## get grid coordnates
	#var x_coord : int = (floor((obj_position.x ) / cell_size)) - 1
	#var y_coord : int = (floor((obj_position.y ) / cell_size)) - 1
	#
	## get top right position of cell
	#var x_position : int = floor(x_coord * cell_size)
	#var y_position : int = floor(y_coord * cell_size)
	#
	#if x_size % 2 == 0:
		#x_position += floor(cell_size/2.0)
	#if y_size % 2 == 0:
		#y_position += floor(cell_size/2.0)
	#return Vector2(x_position  , y_position)

func get_position_coords(obj_position : Vector2)->Vector2i:
	var x_coord : int = (floor((obj_position.x + (cell_size*.1) ) / cell_size)) 
	var y_coord : int = (floor((obj_position.y + (cell_size*.1) ) / cell_size)) 
	return Vector2i(x_coord, y_coord)
	
func track_object_coords(): 
	for obstical in obsticals.get_children():
		if obstical is Obstical: 
			var current_obstical : Obstical = obstical
			obstical_coords[current_obstical] = get_position_coords(current_obstical.position)
