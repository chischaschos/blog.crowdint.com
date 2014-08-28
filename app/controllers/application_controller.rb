class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper

  protect_from_forgery

  before_action :set_meta

  def after_sign_in_path_for(resource)
    crowdblog.admin_root_url
  end

  def after_sign_out_path_for(resource)
    main_app.root_url
  end

  private
  def set_meta
    title = @post ? t('seo.post.title', title: @post.title) : t("seo.#{controller_name}.title", default: :'seo.title')
    description = @post ? strip_tags(truncate(@post.html_body.html_safe, escape: false, length: 130)) : t("seo.#{controller_name}.description", default: :'seo.description')

    set_meta_tags title: title,
      description: description,
      keywords: t("seo.#{controller_name}.tags", default: :'seo.tags'),
      canonical: request.original_url,
      og: {
        url: request.original_url,
        title: title,
        type: 'blog',
        description: description,
        image: image_url

      },
      twitter: {
        site: '@crowdint',
        title: description
      }
  end

  def image_url
    view_context.image_url('crowdint-logo-social.png')
  end

end
