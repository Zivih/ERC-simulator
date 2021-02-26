extends Node
onready var thread = Thread.new()
onready var current_scene =  get_node("/root/Menu")
var lscene = null
func loading(loadingState):
	if(loadingState):
		lscene = load("res://Loading.tscn").instance()
		get_tree().get_root().add_child(lscene)
		loadingState = 0
		lscene.show()
	else:
		lscene.hide()
		lscene.queue_free()
