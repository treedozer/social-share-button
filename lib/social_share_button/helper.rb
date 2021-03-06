module SocialShareButton
  module Helper
    def social_share_button_tag(title = "", opts = {})
      opts.compact.deep_symbolize_keys!
      opts[:allow_sites] ||= SocialShareButton.config.allow_sites

      extra_data  = {}
      rel         = opts[:rel]
      html        = []

      html << "<div class='#{prepare_container_class(opts)}' data-title='#{h title}' #{opts_to_attributes(opts)}>"

      opts[:allow_sites].each do |name|
        extra_data    = opts.select { |k, _| k.to_s.start_with?('data') } if name.eql?('tumblr')
        special_data  = opts.select { |k, _| k.to_s.start_with?('data-' + name) }
        
        special_data['data-wechat-footer'] = t 'social_share_button.wechat_footer' if name == 'wechat'

        link_title    = t 'social_share_button.share_to', :name => t("social_share_button.#{name.downcase}")
        html << link_to('', '#',
                        {
                          rel: ['nofollow', rel],
                          'data-site': name,
                          class: "ssb-icon ssb-#{name}",
                          onclick: 'return SocialShareButton.share(this);',
                          title: h(link_title) }.merge(extra_data).merge(special_data)
        )
      end

      html << "</div>"
      raw html.join("\n")
    end

    def opts_to_attributes(opts)
      opts.except(:allow_sites, :class).map do |k, v|
        "data-#{k.to_s.dasherize}='#{v}'"
      end.join(' ')
    end

    def prepare_container_class(opts)
      "social-share-button #{opts[:class]} #{opts[:allow_sites].map { |s| "ssb-container-#{s}"}.join(' ') }".squish
    end
  end
end
