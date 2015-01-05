# These includes mimic the includes in the phonegap app. Everything
# else is loaded in application_extra.js.coffee

#= require jquery
#= require myplaceonline
#= require jquery.mobile
#= require handlebars-v2.0.0
#= require ember-1.9.0
#= require forge.min

$ ->
  $('body').on('change', 'select.region', ->
    select_wrapper = $('.subregionwrapper')

    $('select', select_wrapper).attr('disabled', true)

    subregion_code = $(this).val()

    url = 
    
    $.get(
      "/api/subregions?regionstr=#{subregion_code}",
      (data) ->
        $(".subregionwrapper").replaceWith(data)
        ensureStyledPage()
    )
  )
