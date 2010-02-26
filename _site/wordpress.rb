require 'rubygems'
require 'sequel'
require 'fileutils'

# NOTE: This converter requires Sequel and the MySQL gems.
# The MySQL gem can be difficult to install on OS X. Once you have MySQL
# installed, running the following commands should work:
# $ sudo gem install sequel
# $ sudo gem install mysql -- --with-mysql-config=/usr/local/mysql/bin/mysql_config

module Jekyll
  module WordPress

    # Reads a MySQL database via Sequel and creates a post file for each
    # post in wp_posts that has post_status = 'publish'.
    # This restriction is made because 'draft' posts are not guaranteed to
    # have valid dates.

    # QUERY = "select post_title, post_name, post_date, post_content, post_excerpt, ID, guid from wp_dnevnik_posts where post_status = 'publish' and post_type = 'post'"

    QUERY = "SELECT wposts.post_title,wposts.post_name,wposts.post_date,wposts.post_content,wp_dnevnik_terms.slug FROM wp_dnevnik_posts wposts
    LEFT JOIN wp_dnevnik_postmeta wpostmeta ON wposts.ID = wpostmeta.post_id 
    LEFT JOIN wp_dnevnik_term_relationships ON (wposts.ID = wp_dnevnik_term_relationships.object_id)
    LEFT JOIN wp_dnevnik_term_taxonomy ON (wp_dnevnik_term_relationships.term_taxonomy_id = wp_dnevnik_term_taxonomy.term_taxonomy_id)
    LEFT JOIN wp_dnevnik_terms ON (wp_dnevnik_term_taxonomy.term_id = wp_dnevnik_terms.term_id)
    WHERE wp_dnevnik_term_taxonomy.taxonomy = 'category'
    AND wposts.post_status = 'publish' and wposts.post_type = 'post';"

    def self.process(dbname, user, pass, host = 'localhost')
      db = Sequel.mysql(dbname, :user => user, :password => pass, :host => host, :encoding => 'utf8')

      FileUtils.mkdir_p "_posts/"

      db[QUERY].each do |post|
        # Get required fields and construct Jekyll compatible name
        title = post[:post_title]
        slug = post[:post_name]
        date = post[:post_date]
        content = post[:post_content]
        category = post[:slug]
        name = "%02d-%02d-%02d-%s.markdown" % [date.year, date.month, date.day,
                                               slug]
        
        # name = "%s-%s.markdown" % [category, slug]

        # Get the relevant fields as a hash, delete empty fields and convert
        # to YAML for the header
        data = {
           'layout' => 'default',
           'title' => title.to_s,
           'excerpt' => post[:post_excerpt].to_s,
           'wordpress_id' => post[:ID],
          'wordpress_url' => post[:guid],
          'category' => category
         }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

        # Write out the data and content to file
        # post_directory = "#{category}/_posts"
        # FileUtils.mkdir_p post_directory

        File.open("_posts/#{name}", "w") do |f|
          f.puts data
          f.puts "---"
          f.puts content
        end
      end

    end
  end
end
