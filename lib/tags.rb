def writetags
  base = "/tags/"
  tags = {}
  # Collect tag and page data
  articles.each do |p|
    next unless p.attributes[:tags]
    p.attributes[:tags].each do |t|
      if tags[t]
        tags[t] = tags[t]+1
      else
        tags[t] = 1
      end
    end
  end

  # sort tags
  tlist = tags.sort_by { |k, v| v }

  # Write pages
  tags.each_pair do |k, v|
    create_tag_page base, k, v
    create_tag_feed_page base, k, 'Atom'
  end

  $mytags = tlist.reverse
end

def my_link_for_tag(tag, base_url, params={})
    base_url = relative_path_to(base_url)
    label = params[:label] || tag
    klass = params[:class] || "label"
    %[<a href="#{h base_url}#{h tag}" rel="tag" class="#{klass}">#{label}</a>]
end

def my_button_for_tag(tag, base_url)
  base_url = relative_path_to(base_url)
  %[<a class="btn btn-mini" href="#{h base_url}#{h tag}" rel="tag">#{h tag}</a>]
end

def my_button_tags_for(item, params={})
  base_url  = params[:base_url]  || @config[:base_url] + '/tags/'
  none_text = params[:none_text] || '(none)'
  separator = params[:separator] || ', '

  if item[:tags].nil? or item[:tags].empty?
    none_text
  else
    item[:tags].map { |tag| my_button_for_tag(tag, base_url) }.join(separator)
  end
end

