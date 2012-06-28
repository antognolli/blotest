# Google plus button
#
# Put the script only once on each page, and the button wherever you want to
# share it
def gplus_script
    if not @config[:gplusshare]
        return ""
    end
    %{
    <script type="text/javascript">
      (function() {
        var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
        po.src = 'https://apis.google.com/js/plusone.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
      })();
    </script>
    }
end

def gplus_button
    if not @config[:gplusshare]
        return ""
    end
    base = @config[:base_url]
    path = @item.identifier
    url = base + path
    %{ <div class="g-plusone" data-size="medium" data-annotation="inline" data-href="#{url}"></div> }
end

# Twitter button
#
# Put the script only once on each page, and the button wherever you want to
# share it
def twitter_script
    if not @config[:twittershare]
        return ""
    end
    %{
   <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
    }
end

def twitter_share_button
    if not @config[:twittershare]
        return ""
    end
    base = @config[:base_url]
    path = @item.identifier
    url = base + path
    %{ <a href="https://twitter.com/share" class="twitter-share-button" data-url="#{url}">Tweet</a> }
end

# Facebook button
#
# Put the script only once on each page, and the button wherever you want to
# share it
def fb_script
    if not @config[:fbshare]
        return ""
    end
    %{
    <div id="fb-root"></div>
    <script>(function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return;
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));</script>
    }
end

def fb_share_button
    if not @config[:fbshare]
        return ""
    end
    base = @config[:base_url]
    path = @item.identifier
    url = base + path
    %{ <div class="fb-like" data-href="#{url}" data-send="false" data-layout="button_count" data-width="450" data-show-faces="false"></div> }
end
