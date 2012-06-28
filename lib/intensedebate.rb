# Intense Debate comments
def intense_debate_comments
    if not @config[:intense_debate]
        return ""
    end

    intense_id = @config[:intense_id]
    %{
    <div id="comments">
        <script>
        var idcomments_acct = '#{intense_id}';
        var idcomments_post_id = '<%= @item.identifier %>';
        var idcomments_post_url;
        </script>
        <span id="IDCommentsPostTitle" style="display:none"></span>
        <script type='text/javascript' src='http://www.intensedebate.com/js/genericCommentWrapperV2.js'></script>
    </div>
    }
end
