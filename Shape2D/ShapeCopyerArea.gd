@tool
class_name ShapeCopyerArea
extends Polygon2D
@export var Target:Polygon2D
@export var ShadowOffset:Vector2 = Vector2(15,20)

func Copy():
	visible = Target.visible
	polygon = Target.polygon
	position = Target.position+ShadowOffset
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Copy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Copy()
