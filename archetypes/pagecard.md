+++
date = '{{ .Date }}'
draft = true
title = '{{ replace .File.ContentBaseName "-" " " | title }}'
description = ''
summary = ''
[build]
list = 'local'
publishResources = false
render = 'never'
[sidebar]
exclude = true
hide = true
[params.card]
link = "https://example.com"
image = "https://placehold.co/800x200"
+++
