# Copyright (c) 2021 Gil Barbosa Reis.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
extends RichTextLabel

export(Array, Resource) var versions = []


func _ready() -> void:
	var new_text = ""
	for v in versions:
		new_text += v.generate_bbcode()
	bbcode_text = new_text
