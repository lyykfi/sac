# Set caret position easily in jQuery
# Written by and Copyright of Luke Morton, 2011
# Licensed under MIT
(($) ->

  # Behind the scenes method deals with browser
  # idiosyncrasies and such
  $.caretTo = (el, index) ->
    if el.createTextRange
      range = el.createTextRange()
      range.move "character", index
      range.select()
    else if el.selectionStart?
      el.focus()
      el.setSelectionRange index, index


  # The following methods are queued under fx for more
  # flexibility when combining with $.fn.delay() and
  # jQuery effects.

  # Set caret to a particular index
  $.fn.caretTo = (index, offset) ->
    @queue (next) ->
      if isNaN(index)
        i = $(this).val().indexOf(index)
        if offset is true
          i += index.length
        else i += offset  if offset
        $.caretTo this, i
      else
        $.caretTo this, index
      next()



  # Set caret to beginning of an element
  $.fn.caretToStart = ->
    @caretTo 0


  # Set caret to the end of an element
  $.fn.caretToEnd = ->
    @queue (next) ->
      $.caretTo this, $(this).val().length
      next()

) jQuery