extends Control

@onready var nick_input: LineEdit = $Panel/VBox/NickInput
@onready var save_button: Button = $Panel/VBox/Buttons/Save
@onready var http: HTTPRequest = $HTTPRequest

var final_score: int = 0

func _ready() -> void:
	save_button.pressed.connect(_on_save_pressed)
	http.request_completed.connect(_on_request_completed)

func set_score(score: int) -> void:
	final_score = score
	$Panel/VBox/CoinsResult.text = "Score: %d" % score

func _on_save_pressed() -> void:
	var nick := nick_input.text.strip_edges()

	if nick.length() < 3:
		nick_input.placeholder_text = "Nickname minimum 3 letters"
		return

	# ✅ PAYLOAD ALINHADO COM O BACKEND
	var payload := {
		"player": nick,
		"points": final_score
	}

	var json := JSON.stringify(payload)

	http.request(
		"http://localhost:8080/scores",
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		json
	)

	save_button.disabled = true

func _on_skip_pressed() -> void:
	queue_free()

func _on_request_completed(result, response_code, headers, body) -> void:
	if response_code == 201:
		save_button.text = "Saved!"
	else:
		save_button.text = "Error saving"
		save_button.disabled = false
