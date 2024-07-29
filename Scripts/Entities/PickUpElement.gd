extends CharacterBody2D

@export var PossibleElements: Array[PackedScene]
var SelectedElement
var SelectedSprite
var Sprite
var Selector = RandomNumberGenerator.new()

func _ready():
	SelectedElement = PossibleElements[Selector.randi_range(0,PossibleElements.size()-1)]
	Sprite = $Sprite2D
	SelectedSprite = Selector.randi_range(0,23)
	Sprite.region_rect = Rect2(Vector2((SelectedSprite%12 * 8), floor(SelectedSprite/12) * 8), Vector2(8, 8))

	print(SelectedElement.resource_name)
