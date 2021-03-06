extends MenuButton

enum {
	UNDO,
	REDO,
	HISTORY,
}
const HISTORY_SUBMENU_NAME = "HistoryPopupMenu"

export(Resource) var history = preload("res://editor/undo/UndoHistory.tres")

onready var menu_popup = get_popup()
var history_submenu = PopupMenu.new()

func _ready() -> void:
	history_submenu.name = HISTORY_SUBMENU_NAME
	history_submenu.connect("about_to_show", self, "_on_history_menu_about_to_show")
	history_submenu.connect("id_pressed", self, "_on_history_menu_id_pressed")
	menu_popup.add_child(history_submenu)
	
	menu_popup.add_item("Undo", UNDO)
	menu_popup.set_item_shortcut(UNDO, preload("res://shortcuts/UndoShortcut.tres"))
	menu_popup.add_item("Redo", REDO)
	menu_popup.set_item_shortcut(REDO, preload("res://shortcuts/RedoShortcut.tres"))
	menu_popup.add_submenu_item("History", HISTORY_SUBMENU_NAME, HISTORY)
	menu_popup.connect("id_pressed", self, "_on_menu_popup_id_pressed")

func _on_menu_popup_id_pressed(id: int) -> void:
	if id == UNDO:
		history.apply_undo()
	elif id == REDO:
		history.apply_redo()

func _on_history_menu_about_to_show() -> void:
	history_submenu.clear()
	for i in range(history.list.size()):
		var id = history.list.size() - i - 1
		var img = history.list[id]
		var tex = ImageTexture.new()
		tex.create_from_image(img)
		var caption = "*" if history.is_current(id) else ""
		history_submenu.add_icon_item(tex, caption, id)

func _on_history_menu_id_pressed(id: int) -> void:
	history.set_current_revision(id)
