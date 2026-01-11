class_name StateMachine extends Node

##I could have just organized this in player.gd as functions but that would have made the script even longer
##and unsostainable so i opted for this, what do you think? as far as i tested in my pc it works just fine

@export var initial_state: State = null

@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()


func _ready() -> void:
	# Give every state a reference to the state machine.
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)

	# State machines usually access data from the root node of the scene they're part of: the owner.
	# We wait for the owner to be ready to guarantee all the data and nodes the states may need are available.
	await owner.ready
	state.enter("")

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)



func _physics_process(delta: float) -> void:
	state.physics_update(delta)
	if get_parent().current_health < 0 and state.name != "Dead":
		_transition_to_next_state("Dead")


func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path): #error handler
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return
	#we save the current state name
	var previous_state_path := state.name
	#first we call the function of the state to exit, an example of this is crouched state
	#since it haves to restore the collision shape and camera3d to where it was
	state.exit()
	#we update de var to the new state we want to change
	state = get_node(target_state_path)
	#we change to the new state while passing what state was before of it
	#this is very useful if you want to make something different depending on the previous state
	#like playing a roll animation if the previous state was falling
	state.enter(previous_state_path, data)
