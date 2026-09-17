+++
date = '{{ .Date }}'
draft = true
title = '{{ replace .File.ContentBaseName "-" " " | title }}'
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
