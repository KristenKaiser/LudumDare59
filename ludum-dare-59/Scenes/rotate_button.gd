extends Button
enum Direction{LEFT, RIGHT}
@export var rotate_direction : Direction 

const ROTATE_ARROW_RIGHT = preload("uid://barm3lxouw5rf")
const ROTATE_ARROW_LEFT = preload("uid://b0s2owpgng8hh")

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	

func _on_mouse_entered() -> void:
	await get_tree().process_frame
	var scaled_image : Image
	if rotate_direction == Direction.RIGHT: 
		scaled_image = ROTATE_ARROW_RIGHT.get_image()
	else: 
		scaled_image = ROTATE_ARROW_LEFT.get_image()
	
	scaled_image.resize(floor(Global.grid.cell_size/2.0), floor(Global.grid.cell_size/2.0)) # TODO snap to 2bit int
	var scaled_texture = ImageTexture.create_from_image(scaled_image) 
	Input.set_custom_mouse_cursor(scaled_texture, Input.CURSOR_ARROW) # TODO move hotspot

func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)
