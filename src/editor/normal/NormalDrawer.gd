# Copyright (c) 2021 Gil Barbosa Reis.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
extends Viewport

export(Resource) var project = preload("res://editor/project/ActiveEditorProject.tres")
export(ShaderMaterial) var height_to_normal_material = preload("res://editor/normal/HeightToNormal_material.tres")

var _canvas_item
onready var is_gles3 = OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3


func _ready() -> void:
	get_texture().flags = Texture.FLAG_FILTER
	
	_canvas_item = VisualServer.canvas_item_create()
	VisualServer.canvas_item_set_parent(_canvas_item, find_world_2d().canvas)
	VisualServer.canvas_item_set_material(_canvas_item, RID(height_to_normal_material))
	
	_on_height_drawer_size_changed()
	var _err = HeightDrawer.connect("size_changed", self, "_on_height_drawer_size_changed")
	_err = HeightDrawer.connect("brush_drawn", self, "update_height_in_rect")
	_err = HeightDrawer.connect("cleared", self, "_on_height_drawer_cleared")


func update_height_in_rect(rect: Rect2) -> void:
	var region = rect.grow(1).clip(Rect2(Vector2.ZERO, size))
	VisualServer.canvas_item_clear(_canvas_item)
	HeightDrawer.get_texture().draw_rect_region(_canvas_item, region, region)
	render_target_update_mode = Viewport.UPDATE_ONCE


func _on_normal_texture_changed(texture: Texture) -> void:
	VisualServer.canvas_item_clear(_canvas_item)
	texture.draw(_canvas_item, Vector2.ZERO)
	render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	render_target_update_mode = Viewport.UPDATE_ONCE


func take_snapshot() -> void:
	project.normal_image = get_texture().get_data()
	project.normal_image.convert(HeightMapData.NORMAL_IMAGE_FORMAT)
	project.normal_texture.create_from_image(project.normal_image, project.normal_texture.flags)


func _on_height_drawer_size_changed() -> void:
	var new_size = HeightDrawer.size
	if not new_size.is_equal_approx(size):
		size = new_size
		render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME


func _on_height_drawer_cleared() -> void:
	update_height_in_rect(Rect2(Vector2.ZERO, size))
