@tool
class_name TextData
extends Resource


@export var DefaultHead:TextHeader = TextHeader.new()

@export_multiline var Text:String

@export var HeadList:Array[TextHeader] = []
