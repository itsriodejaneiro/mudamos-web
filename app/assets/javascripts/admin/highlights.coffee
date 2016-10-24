$ ->
  $('form.formtastic.grid_highlight').each ->
    $(this).find('input[type="submit"]').click (e) ->
      e.stopPropagation();
      e.preventDefault();

      form = $(this).parents('form:first')
      class_name = form.find('select#grid_highlight_target_object_type').val()

      if class_name != ''
        select = form.find("select[name$=#{class_name}]")

      form.find('li.input').not('.hidden').not('#grid_highlight_target_object_type_input').addClass('hidden')

      if select
        li = select.parents('li.input:first')
        li.removeClass('hidden')
        name = select.attr('name')

        if name
          new_name = name.split("_#{class_name}")[0]
          select.attr('name', new_name)

      form.find('li.input.hidden').remove()
      form.submit()


  $("select#grid_highlight_target_object_type").change ->
    form = $(this).parents('form:first')
    class_name = $(this).val()

    if class_name != ''
      select = form.find("select[name$=#{class_name}]")

    form.find('li.input').not('.hidden').not('#grid_highlight_target_object_type_input').addClass('hidden')

    if select
      select.parents('li.input:first').removeClass('hidden')

  $("select#grid_highlight_target_object_type").change()
