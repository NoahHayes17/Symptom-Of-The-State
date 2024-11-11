extends Node2D

@export var display_time: float = 4.0

# NPC and player dialogue arrays
var npc_dialogue_lines: Array = [
	"",
	"Today, we received more info: white hair or eyelashes may indicate risk factors.",
	"All our local systems got a new app installed where you can see photos of patients which other doctors have taken in light of the new information regarding symptoms. It’s crucial to cross-check the last few cases to be thorough.",
]

var player_responses: Array = [
	"[wave]Hello Doctor[/wave]",
	"[wave]Thats very useful, thank you again.[/wave]",
	"[wave]Ah, rather neet. I'll check now[/wave]",
]

# NPC responses to acceptance and rejection
var npc_accept_response: String = "I'm glad you accepted! Let's work together!"
var npc_reject_response: String = "Oh, I see... Well, good luck then!"

# Track the current dialogue line
var current_line: int = 0

func _ready():
	$Advance/RichTextLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$InspectEye/RichTextLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$InspectVein/RichTextLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Accept/RichTextLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Reject/RichTextLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$BackgroundCoverUp/Panel/Close/RichTextLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$BackgroundCoverUp/Panel/Time/RichTextLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	update_dialogue()

# Function to update the dialogue box based on the current line
func update_dialogue():
	if current_line < npc_dialogue_lines.size():
		show_text($NPCText/RichTextLabel, npc_dialogue_lines[current_line])  # Show NPC line gradually
		$Advance/RichTextLabel.text = player_responses[current_line]  # Show player's response as button text
	else:
		end_dialogue()  # End dialogue if no more NPC lines

# Coroutine to reveal the text character by character
func show_text(label: RichTextLabel, text: String) -> void:  # Accept Control as the argument
	label.clear()  # Start with an empty label
	for character in text:  # Renamed char to character
		label.append_text(character)
		await get_tree().create_timer(0.05).timeout  # Wait for 0.05 seconds for speed adjustment

# Advances to the next dialogue line when the player response is pressed

# Ends the dialogue and shows choice buttons
func end_dialogue():
	$Advance.hide()  # Hide the advance button
	$Accept.show()  # Show the accept button
	$Reject.show()  # Show the reject button

# Advances to the next dialogue line when the player response is pressed
func _on_advance_pressed():
	print("Button pressed! Current line:", current_line)  # Debugging line
	current_line += 1  # Increment to the next dialogue line
	update_dialogue()

# Function to end the scene
func end_scene():
	var new_scene = load("res://Worker/Worker.tscn").instantiate()
	get_tree().root.add_child(new_scene)
	queue_free()  # Optionally, remove the current scene if needed

	#get_tree().quit()
