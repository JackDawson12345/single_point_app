# app/helpers/admin/themes_helper.rb
module Admin::ThemesHelper
  def theme_usage_count(theme)
    pluralize(theme.websites.count, 'website')
  end

  def theme_status_badge(theme)
    if theme.active?
      content_tag :span, 'Active', class: 'badge bg-success'
    else
      content_tag :span, 'Inactive', class: 'badge bg-secondary'
    end
  end

  def format_json_for_display(json_data)
    return 'No data' if json_data.blank?

    begin
      JSON.pretty_generate(json_data)
    rescue
      json_data.to_s
    end
  end

  def css_variables_preview(css_variables)
    return '' if css_variables.blank?

    styles = css_variables.map do |key, value|
      "--#{key.gsub('_', '-')}: #{value};"
    end.join(' ')

    content_tag :div, 'Preview',
                style: styles + ' padding: 1rem; background: var(--background-color, #fff); color: var(--text-color, #333); border: 2px solid var(--primary-color, #007bff);',
                class: 'theme-preview-box'
  end
end