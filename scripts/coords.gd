extends Label

var visible_coord_x = 0
var visible_coord_y = 0

var real_coords = Vector2.ZERO
const UMBRAL = 10  # Cada 10 coordenadas REALES que se avanzan, se avanzara 1 en las coordenadas mostradas

func _ready():
	real_coords = global.player_position
	visible_coord_x = int(real_coords.x / UMBRAL)
	visible_coord_y = int(real_coords.y / UMBRAL)
	show_coords()

func _process(_delta):
	var real_pos = global.player_position
	
	var new_visible_x = int(real_pos.x / UMBRAL)
	var new_visible_y = int(real_pos.y / UMBRAL)
	
	if new_visible_x != visible_coord_x or new_visible_y != visible_coord_y:
		visible_coord_x = new_visible_x
		visible_coord_y = new_visible_y
		show_coords()
		
func show_coords():
	text = "X: %d, Y: %d" % [visible_coord_x, visible_coord_y]
