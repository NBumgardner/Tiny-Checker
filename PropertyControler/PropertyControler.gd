class_name PropertyControler
extends Node2D

@export var Getters : Array[GetterNode] = []

@export var Inners:Array[InnerNode] = []

@export var Setters:Array[SetterNode] = []

@export var Targets:Array[Node] = []

var active:bool = true

func _initSetters():
	for i in Setters:
		if i.TargetIndex<0:
			i.target = self
		else:
			i.target = Targets[i.TargetIndex]

func _initInners():
	for i in Inners:
		i.InitNode()

func _initNodes():
	_initSetters()
	_initInners()
	
func _updateNodes(dt:float):
	for i in Getters:
		if not i.updated:
			i.UpdateNode(dt)
	for i in Inners:
		if not i.updated:
			i.UpdateNode(dt)
	for i in Setters:
		if not i.updated:
			i.UpdateNode(dt)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		Targets.append(i)
	_initNodes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		_updateNodes(delta)
