# app/helpers/manage/websites_helper.rb
module Manage::WebsitesHelper
  def theme_preview_image(theme)
    if theme.preview_image.present?
      image_tag theme.preview_image,
                alt: theme.name,
                class: 'img-fluid theme-preview'
    else
      content_tag :div, class: 'theme-preview-placeholder d-flex align-items-center justify-content-center' do
        content_tag :span, theme.name.first(2).upcase, class: 'theme-initials'
      end
    end
  end

  def website_status_badge(website)
    if website.published?
      content_tag :span, 'Published', class: 'badge bg-success'
    else
      content_tag :span, 'Draft', class: 'badge bg-warning'
    end
  end

  def page_type_icon(page_type)
    icons = {
      'home' => 'fas fa-home',
      'about' => 'fas fa-info-circle',
      'services' => 'fas fa-briefcase',
      'contact' => 'fas fa-envelope'
    }
    content_tag :i, '', class: icons[page_type] || 'fas fa-file'
  end

  def customization_input(form, variable, current_value, default_value, css_variables)
    case variable
    when /color/
      form.color_field "customizations[#{variable}]",
                       value: current_value || default_value,
                       class: 'form-control form-control-color'
    when /font/
      form.select "customizations[#{variable}]",
                  font_family_options,
                  { selected: current_value || default_value },
                  { class: 'form-control' }
    when /size|width|height|margin|padding/
      form.text_field "customizations[#{variable}]",
                      value: current_value || default_value,
                      class: 'form-control',
                      placeholder: 'e.g., 16px, 1rem, 100%'
    else
      form.text_field "customizations[#{variable}]",
                      value: current_value || default_value,
                      class: 'form-control'
    end
  end

  private

  def font_family_options
    [
      ['Arial', 'Arial, sans-serif'],
      ['Georgia', 'Georgia, serif'],
      ['Times New Roman', 'Times New Roman, serif'],
      ['Helvetica', 'Helvetica, sans-serif'],
      ['Roboto', 'Roboto, sans-serif'],
      ['Montserrat', 'Montserrat, sans-serif'],
      ['Open Sans', 'Open Sans, sans-serif'],
      ['Lato', 'Lato, sans-serif'],
      ['Source Sans Pro', 'Source Sans Pro, sans-serif'],
      ['Merriweather', 'Merriweather, serif']
    ]
  end
end