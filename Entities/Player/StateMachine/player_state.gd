class_name PlayerState extends State

# const name must be un uppercase and the string MUST match the node name
const IDLE = "Idle"
const WALKING = "Walking"
const RUN = "Run"
const JUMPING = "Jumping"
const FALLING = "Falling"
const CROUCH = "Crouch"
const DEAD = "Dead"
const STOP = "Stop"
var player: Player

func update(delta: float) -> void:
	if %ChatPanel.visible == true:
		finished.emit(STOP)

func _ready() -> void:
	await owner.ready
	player = owner as Player #not really necesary but i did this to have autocompletion
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
