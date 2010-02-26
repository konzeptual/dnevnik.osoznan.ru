# -*- coding: utf-8 -*-
desc 'Generate tags page'
task :tags do
  puts "Generating tags..."
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  list_of_categories = '<ul>'

  site.categories.sort.each do |category, posts|
    list_of_categories << <<-HTML
  <li class="page_item"><a href="/rubrika/#{category}">#{category}</a></li>
HTML

    list_of_posts_in_category = ''
    list_of_posts_in_category << <<-HTML
---
layout: default
title: Рубрика "#{category}"
---
<h1 id="#{category}">Записи в категории "#{category}"</h1>
    {% for page in site.categories.#{category} %}
      {% include single_post.html %}
    {% endfor %}
HTML

    category_dir = "rubrika/#{category}"
    FileUtils.mkdir_p category_dir
    File.open("#{category_dir}/index.html", 'w+') do |file|
      file.puts list_of_posts_in_category
    end
  end

  File.open("rubrika/index.html", 'w+') do |file|
    file.puts <<-HTML
---
 layout: default
 title: Categories
---
<h2>Рубрики</h2>
HTML
    file.puts list_of_categories
  end

  File.open("_includes/category_list.html", 'w+') do |file|
    file.puts list_of_categories
  end

  puts 'Done.'
end
