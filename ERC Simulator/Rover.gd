extends VehicleBody

const STEER_SPEED = 1
const STEER_LIMIT = 0.4

var steer_target = 0
var frontleftwheel = null
var midleftwheel = null
var backleftwheel = null
var frontrightwheel = null
var midrightwheel = null
var backrightwheel = null

#forse conviene usare un parametro globale del rover per la roll influence
#così specifichiamo la rotazione sui vari terreni evitando lo scivolamento
export var engine_force_value = 40
func _ready():
	frontleftwheel = $Wheel1
	midleftwheel = $MidWheelL
	backleftwheel = $Wheel2
	frontrightwheel = $Wheel3
	midrightwheel = $MidWheelR
	backrightwheel = $Wheel4
	
func _physics_process(delta):
	var fwd_mps = transform.basis.xform_inv(linear_velocity).x

	#steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")
	#steer_target *= STEER_LIMIT
	if Input.is_action_pressed("turn_right"):
		frontleftwheel.engine_force = engine_force_value
		midleftwheel.engine_force = engine_force_value
		backleftwheel.engine_force = engine_force_value
		frontrightwheel.engine_force = -engine_force_value
		midrightwheel.engine_force = -engine_force_value
		backrightwheel.engine_force = -engine_force_value
		
	elif Input.is_action_pressed("turn_left"):
		frontleftwheel.engine_force = -engine_force_value
		midleftwheel.engine_force = -engine_force_value
		backleftwheel.engine_force = -engine_force_value
		frontrightwheel.engine_force = engine_force_value
		midrightwheel.engine_force = engine_force_value
		backrightwheel.engine_force = engine_force_value
		
	elif Input.is_action_pressed("accelerate"):
		frontleftwheel.engine_force = engine_force_value
		midleftwheel.engine_force = engine_force_value
		backleftwheel.engine_force = engine_force_value
		frontrightwheel.engine_force = engine_force_value
		midrightwheel.engine_force = engine_force_value
		backrightwheel.engine_force = engine_force_value
		#engine_force = 0

	elif Input.is_action_pressed("reverse"):
		if (fwd_mps >= -1):
			frontleftwheel.engine_force = -engine_force_value
			midleftwheel.engine_force = -engine_force_value
			backleftwheel.engine_force = -engine_force_value
			frontrightwheel.engine_force = -engine_force_value
			midrightwheel.engine_force = -engine_force_value
			backrightwheel.engine_force = -engine_force_value
		else:
			frontleftwheel.brake = 1
			midleftwheel.brake = 1
			backleftwheel.brake = 1
			frontrightwheel.brake = 1
			midrightwheel.brake = 1
			backrightwheel.brake = 1
	else:
		frontleftwheel.engine_force = 0
		midleftwheel.engine_force = 0
		backleftwheel.engine_force = 0
		frontrightwheel.engine_force = 0
		midrightwheel.engine_force = 0
		backrightwheel.engine_force = 0
		frontleftwheel.brake = 1
		frontrightwheel.brake = 1
		midleftwheel.brake = 1
		backleftwheel.brake = 1
		midrightwheel.brake = 1
		backrightwheel.brake = 1

	#steering = move_toward(steering, steer_target, STEER_SPEED * delta)
