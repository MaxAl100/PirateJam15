extends TileMap

@export var width = 100
@export var height = 60

@export var BigCells: Array[Vector2i]

var playerPosition: Vector2i

var Selector = RandomNumberGenerator.new()
var last_player_position: Vector2i

var TimeToUpdateMax = 0.3
var CurrentTimeToUpdate = 0


func _ready():
	var initial_position = get_player_position()
	last_player_position = initial_position
	around_player(initial_position)

func _process(delta):
	var current_position = get_player_position()
	CurrentTimeToUpdate -= delta
	if last_player_position != current_position && CurrentTimeToUpdate <= 0:
		around_player(current_position)
		last_player_position = current_position
		CurrentTimeToUpdate = TimeToUpdateMax

func around_player(pos):
	var half_width = width / 2
	var half_height = height / 2
	for x in range(width):
		for y in range(height):
			var cell_pos = Vector2i(x - half_width, y - half_height) + pos
			if get_cell_tile_data(0, cell_pos) == null:
				set_cell(0, cell_pos, 0, Vector2i(50, 30))
				if (x+pos.x) % 60 == 0 and (y+pos.y) % 40 == 0:
					set_big_cell(cell_pos)
				

func set_big_cell(pos):
	if get_cell_tile_data(1, pos) != null:
		return
	var selectedSymbol = BigCells[Selector.randi_range(0, BigCells.size() - 1)]
	set_cell(1, pos, 1, selectedSymbol)

func get_player_position() -> Vector2i:
	return playerPosition

func set_player_position(pos):	
	playerPosition = Vector2i(pos.x/8,pos.y/8)
