---
layout: page
title: full artist list
permalink: /band-list/
---

{% for band in site.band_list %}
<h4>{{ band }}
<br>
{% for post in site.posts reversed %}
{% if post.title == band %}
<a href="{{ site.baseurl }}{{ post.url }}"><img src="{{ post.img }}" style="vertical-align:middle" height="150px"></a>
{% endif %}
{% endfor %}
<br><br></h4>
{% endfor %}