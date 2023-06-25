# offhab-scripts

helper scripts in R for assessing Offshore Wind Energy Habitats 

## html

These web pages (\*.html) are typically rendered in this repository from Rmarkdown (\*.Rmd) or Quarto markdown (\*.qmd) source documents:

<!-- Jekyll rendering: https://marineenergy.github.io/apps/ -->
{% for file in site.static_files %}
  {% if file.extname == '.html' %}
* [{{ file.basename }}]({{ site.baseurl }}{{ file.path }})
  {% endif %}
{% endfor %}

