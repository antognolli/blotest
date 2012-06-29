def create_tag_page(base, tag, count)
    meta = {}
    meta[:title] = "Tag: #{tag}"
    meta[:kind] = 'page'
    meta[:filters_pre] = ['erb']
    meta[:feed] = "/tags/#{tag}/"
    meta[:feed_title] = "Tag '#{tag}'"
    meta[:permalink] = tag
    pl = (count == 1) ? ' is' : 's are'
    contents = %{
        <% feed = "/tags/#{tag}-atom/" %>
        <p>#{count} item#{pl} tagged with <em>#{tag}</em> (<%= link_to("subscribe", relative_path_to(feed)) %>):</p>
            <ul>
            <% articles_sort(items_with_tag('#{tag}')).each do |a| %>
            <%= a.compiled_content :rep => :intro, :snapshot => :post %>
            <% end %>
            </ul>
    }
    # Write page
    create_item base + tag + '/', meta, contents
end

def create_tag_feed_page(base, tag, format)
    title = @config[:title]
    f = format.downcase
    meta = {}
    meta[:title] = "#{title} - Tag '#{tag}' (#{format} Feed)"
    meta[:kind] = 'feed'
    meta[:permalink] = "tags/#{tag}/#{f}"
    contents = %{<%= #{f}_feed(:articles => items_with_tag('#{tag}'))%>}
    create_item base + tag + "-#{f}/", meta, contents
end

def create_base_feed_page(base, format)
    title = @config[:title]
    f = format.downcase
    meta = {}
    meta[:title] = "#{title} (#{format} Feed)"
    meta[:kind] = 'feed'
    meta[:permalink] = base + "feed/"
    contents = %{<%= atom_feed %>}
    create_item base + "feed/", meta, contents
end

def create_old_page(base, idx, last_idx, num)
    first = idx * num + 1
    last = (idx + 1) * num
    meta = {}
    meta[:title] = "Home - page #{idx + 1}"
    meta[:kind] = 'page'
    meta[:old_idx] = idx

    if idx == 1
        meta[:prev_idx] = "/"
    else
        meta[:prev_idx] = base + "#{idx}"
    end

    if idx == last_idx
        meta[:next_idx] = nil
    else
        meta[:next_idx] = base + "#{idx + 2}"
    end

    contents = %{
        <% pages = sorted_articles.slice(@item[:old_idx] * #{num}, #{num}) %>
        <% pages.each do |a| %>
        <div class="row-fluid">
          <div class="span12">
            <%= a.compiled_content :rep => :intro, :snapshot => :post %>
          </div>
        </div>
        <% end %>
        <div class="row-fluid">
          <div class="span12">
            <a href="<%= @item[:prev_idx] %>">&laquo Newer</a>
            <% if not @item[:next_idx].nil? %>
            <a class="pull-right" href="<%= @item[:next_idx] %>">Older &raquo</a>
            <% end %>
          </div>
        </div>
    }
    create_item base + "#{idx + 1}", meta, contents
end

def create_archive_page(dir, name, count)
    meta = {}
    meta[:title] = "Archive: #{name}"
    meta[:kind] = 'page'
    meta[:filters_pre] = ['erb']
    meta[:permalink] = name.downcase.gsub /\s/, '-'
    pl = (count == 1) ? ' was' : 's were'
    contents = %{
        <p>#{count} article#{pl} written in <em>#{name}</em>:</p>
            <ul>
            <% articles_by_month.select{|i| i[0] == "#{name}"}[0][1].each do |a|%>
            <%= render 'dated_article', :article => a %>
            <% end %>
            </ul>
    }
    # Write file
    write_item dir/"#{meta[:permalink]}.html", meta, contents
end

# def write_item(path, meta, contents)
#     path.parent.mkpath
#     (path).open('w+') do |f|
#         f.print "--"
#         f.puts meta.to_yaml
#         f.puts "-----"
#         f.puts contents
#     end
# end

def create_item(base, meta, contents)
    it = Nanoc::Item.new(contents, meta, base)
    @items << it
end

def items_for_preview
    @items.select { |item| item[:kind] == 'preview' }
end

def my_link_to(text, target, attributes={})
  # Find path
  path = target.is_a?(String) ? target : target.path
  target = relative_path_to(target)

  if @item_rep && @item_rep.path == path
    # Create message
    "<li class=\"active\">" + link_to(text, target, attributes) + "</li>"
  else
    "<li>" + link_to(text, target, attributes) + "</li>"
  end
end

def articles_sort(art)
    if art.any?
        art.sort_by do |a|
            attribute_to_time(a[:created_at])
        end.reverse
    else
        art
    end
end
