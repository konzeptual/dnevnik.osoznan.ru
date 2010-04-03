# -*- coding: utf-8 -*-

namespace :site do
  task :jekyll => :tags do
    sh "PATH=$PATH:~/.gem/ruby/1.8/bin jekyll --bluecloth --permalink shortdate"
  end

  desc 'Generate tags page'
  task :tags do
    puts "Generating categories..."
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

      category_dir = "rubrika/#{category}"
      FileUtils.mkdir_p category_dir
      File.open("#{category_dir}/index.html", 'w+') do |file|
        file.puts <<-HTML
---
layout: index
title: Рубрика "#{category}"
categories: [#{category}]
---
HTML
      end
    end

    File.open("rubrika/index.html", 'w+') do |file|
      file.puts <<-HTML
---
 layout: default
 title: Доступные рубрики
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

  # http://github.com/mattmatt/paperplanes/blob/master/Rakefile
  namespace :jekyll do
    task :server do
      sh "jekyll"
    end
  end

  task :purge do
    sh "rm _site/Capfile _site/README.markdown _site/Rakefile"
  end

  task :generate => ["jekyll", "purge"]

  task :clean do
    sh "rm -rf _site"
  end
end

task :publish do
  sh "git push origin master && cap deploy "
end
