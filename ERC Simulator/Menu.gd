extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var task = null
var thread = null
var th_flag = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _exit_tree():
	thread.wait_to_finish()

func loadingScene():
	var scene = load("res://Loading.tscn").instance()
	add_child(scene)
	show()
	
func loadTask(taskName):
	#caricamento da affidare ad un thread?
	task = ResourceLoader.load(taskName).instance()
	#task.get_node("RifSpatial/MeshInstance")._ready()
	add_child(task)
	print("caricato")
	Global.loading(0)
	hide()

func _on_ScienceTaskButton_pressed():
	#avvia il thread per la scena di caricamento
	Global.loading(1)
	thread = Thread.new()
	thread.start(self,"loadTask","res://ScienceTask.tscn")
	#loadTask("res://ScienceTask.tscn")
func _on_TraverseTaskButton_pressed():
	pass


func _on_MaintenanceTaskButton_pressed():
	pass


func _on_CollectionTaskButton_pressed():
	pass
