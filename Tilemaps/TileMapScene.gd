extends TileMap


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func around_player(position):
	for x in 40:
		for y in 30:
			if get_cell_tile_data(0, Vector2i(x-20,y-15)) == null:
				set_cell(0, Vector2i(x-20,y-15),1, Vector2i(0,0))
