# Copyright (c) 2021 Gil Barbosa Reis.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
extends "res://editor/visualizers/VisualizerContainer.gd"

export(float) var min_zoom_size: float = 200
export(float) var max_zoom_size: float = 4


func _process(delta: float) -> void:
	if pan_modifier:
		var factor = (faster_factor if Input.is_action_pressed("visualizer_3d_faster") else 1.0) * speed * delta
		var movement = Vector2(
			Input.get_action_strength("visualizer_3d_rotate_left") - Input.get_action_strength("visualizer_3d_rotate_right"),
			Input.get_action_strength("visualizer_3d_rotate_up") - Input.get_action_strength("visualizer_3d_rotate_down")
		)
		update_camera_with_pan(movement * factor)


func update_camera_with_pan(pan: Vector2) -> void:
	var projected_zero = camera.project_position(Vector2.ZERO, 0)
	var projected_pan = camera.project_position(pan, 0)
	var projected_delta = projected_zero - projected_pan
	camera.translate_object_local(Vector3(projected_delta.x, projected_delta.y, 0))


func set_camera_zoom_percent(percent: float) -> void:
	camera.size = lerp(min_zoom_size, max_zoom_size, percent)
