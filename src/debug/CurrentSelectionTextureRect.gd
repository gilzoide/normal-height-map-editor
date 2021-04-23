# Copyright (c) 2021 Gil Barbosa Reis.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
extends TextureRect

onready var SelectionDrawer = preload("res://editor/selection/SelectionDrawer.tscn").instance()

func _ready() -> void:
	texture = SelectionDrawer.get_texture()
