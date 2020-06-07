extends Object

class_name StateMachine

var currentState:State = null

func _init(state:State = null):
	currentState = state
	if currentState != null:
		currentState.enter()
	pass

func change_state(state:State):
	if currentState != null :
		currentState.exit()
		currentState.call_deferred("free")
	
	currentState = state
	
	if currentState != null :
		currentState.enter()

func update():
	if currentState != null :
		currentState.execute()
	
func is_state(stateName:String):
	if currentState == null :
		return false
	return currentState.get_name() == stateName
