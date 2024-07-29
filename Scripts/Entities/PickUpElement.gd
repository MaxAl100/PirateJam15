extends CharacterBody2D

@export var PossibleElements: Array[PackedScene]
var SelectedElement
var Selector = RandomNumberGenerator.new()

func _ready():
	SelectedElement = PossibleElements[Selector.randi_range(0,PossibleElements.size()-1)]
	print(SelectedElement.resource_name)
