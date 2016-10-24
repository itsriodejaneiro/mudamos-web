$(window).load ->
  $('.content-area').children('.content').each ->
    document.add_dotdotdot_to_comment $(this)

  $('.readmore').each ->
    document.add_readmore_to_comment $(this)


document.add_dotdotdot_to_comment = (elem) ->
  total_height = 0

  comment = elem.find('.comment-dotdotdot')
  children = comment.children()

  children.each ->
    total_height += $(this).height()

  if total_height > comment.height()
    elem.find('a.readmore:first').addClass('clickable')
  else
    elem.find('a.readmore:first').remove()

document.add_readmore_to_comment = (elem) ->
  elem.click ->
    wrapper = $(this).parents(".content:first").find(".comment-dotdotdot:first")
    wrapper.removeClass('comment-dotdotdot')
    # wrapper.triggerHandler("destroy")

    $(this).addClass('hidden')
    $(this).parents('.content').children('.readless').removeClass('hidden')

    $('.readless').each ->
      document.add_readless_to_comment $(this)

# $ ->
#   $('.readless').click ->
#     $(this).closest('.content').children('.comment-content').addClass('comment-dotdotdot')
#     $(this).addClass 'hidden'
#     $(this).parents('.content').children('.readmore').removeClass('hidden')

document.add_readless_to_comment = (elem) ->
  elem.click ->
    $(this).closest('.content').children('.comment-content').addClass('comment-dotdotdot')
    $(this).addClass 'hidden'
    $(this).parents('.content').children('.readmore').removeClass('hidden')


