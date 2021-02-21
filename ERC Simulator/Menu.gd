extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var task = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func loadTask(taskName):
	var rover = load("res://rover.tscn").instance()
	rover.set_name("rover")
	task = load(taskName).instance()
	task.get_node("roverinstancepos").add_child(rover)
	get_parent().add_child(task)
	hide()
	pass

func _on_ScienceTaskButton_pressed():
	loadTask("res://ScienceTask.tscn")
	pass # Replace with function body.


func _on_TraverseTaskButton_pressed():
	pass # Replace with function body.


func _on_MaintenanceTaskButton_pressed():
	pass # Replace with function body.


func _on_CollectionTaskButton_pressed():
	pass # Replace with function body.
