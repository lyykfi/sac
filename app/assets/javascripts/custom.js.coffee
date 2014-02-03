#===================== initial block for initiate page at the first load
$(document).ready ->
  initResizable()
  initCrudCheckboxes()
  initSideMenu()
  initHeaderMenu()
  initEditMode()
  initEditButton()
  initBestInPlace()
  initHiddenFields()
  initAjax()
  initNewModal()
  initDelete()
  initSearch()
  initDatetimePicker()

#===================== init datetime picker format
initDatetimePicker = () ->
  $.extend $.fn.datepicker.defaults,
           format: "dd-mm-yyyy"

#===================== init loading v-align
initLoadingModal = () ->
  $('#loading').css('top', 50)
  $('#loading').css('left', 100)

#===================== init resizable of the data-table
initResizable = () ->
  $('#table > thead > tr > th').resizable
    handles:'e'

#===================== init side (left) nav menu - highlight menu item depends on current url
initSideMenu = () ->
  items = $('#side-menu > ul > li')
  items.each ->
    link = $(this).find('a').attr('href')
    $(this).addClass('active') if window.location.pathname == link

#===================== init header nav menu - highlight menu item depends on current url
initHeaderMenu = () ->
  items = $('#header').find('li')
  items.each ->
    link = $(this).find('a').attr('href')
    $(this).addClass('active') if window.location.pathname == link

#===================== init inline editable fields of the data-table
initBestInPlace = () ->
  $('.best_in_place').best_in_place()

#===================== init default hidden fields values
initHiddenFields = () ->
  setHiddenPage(1)

#===================== init ajax request for the data-table paging and ordering
initAjax = () ->
  $("#data-table .pagination a").each ->
    $(this).click ->
      setHiddenPage(getParameterByName('page', $(this).attr('href')))
      tableRequest()
  $(".column-header a").each ->
    $(this).click ->
      setHiddenSort(getParameterByName('sort', $(this).attr('href')))
      setHiddenDirection(getParameterByName('direction', $(this).attr('href')))
      tableRequest()

#===================== init data-table checkboxes for multiple editing
initCrudCheckboxes = () ->
  $('#check-header').click ->
    $(this).closest('table').find('.check-row').prop('checked', this.checked)
    if this.checked
      $('.check-row').addClass('checked')
    else
      $('.check-row').removeClass('checked')
  $('.check-row').click ->
    if this.checked
      $(this).addClass('checked')
    else
      $(this).removeClass('checked')

#===================== init default editable mode of the data-table and behavior for the edit button with notice
initEditMode = () ->
  if getHiddenEditable() == "true"
    $('#edit').click ->
      $('#edit-alert').removeClass('active')
      $(this).removeClass('btn-info')
      setHiddenEditable("false")
      initLoadingModal()
      $('#loading').modal('show')
      tableRequest()
  else
    $('#edit').click ->
      $('#edit-alert').addClass('active')
      $(this).addClass('btn-info')
      setHiddenEditable("true")
      initLoadingModal()
      $('#loading').modal('show')
      tableRequest()

#===================== init behavior for the edit button with notice
initEditButton = () ->
  if getHiddenEditable() == "true"
    $('#edit-alert').addClass('active')
    $('#edit').addClass('btn-info')
  else
    $('#edit-alert').removeClass('active')
    $('#edit').removeClass('btn-info')

#===================== main ajax request, that's manipulates data-table
@tableRequest = () ->
  page = getHiddenPage()
  sort = getHiddenSort()
  direction = getHiddenDirection()
  editable = getHiddenEditable() == "true"
  search = getHiddenSearch()

  $.ajax
    type: 'GET'
    url: this.href
    dataType: 'script'
    data: 'editable=' + editable + '&sort=' + sort + '&direction=' + direction + '&page=' + page + '&search=' + search
    cache: false
    complete: () ->
      initAjax()
      initEditMode()
      initEditButton()
      initCrudCheckboxes()
      initNewModal()
      initDelete()
      initSideMenu()
      initHeaderMenu()
      initResizable()
      $('#loading').modal('hide')
      initDatetimePicker()
      initSearch()

  false

#===================== helpers for getting access to the hidden fields, required for storage data per ajax requests
setHiddenPage = (page) ->
  $('#page').val(page)
setHiddenSort = (sort) ->
  $('#sort').val(sort)
setHiddenDirection = (direction) ->
  $('#direction').val(direction)
setHiddenEditable = (editable) ->
  $('#editable').val(editable)
setHiddenSearch = (search) ->
  $('#search').val(search)

getHiddenPage = () ->
  $('#page').val()
getHiddenSort = () ->
  $('#sort').val()
getHiddenDirection = () ->
  $('#direction').val()
getHiddenEditable = () ->
  $('#editable').val()
getHiddenSearch = () ->
  $('#search').val()

#===================== url-parameters helper
getParameterByName = (name, location) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regexS = "[\\?&]" + name + "=([^&#]*)"
  regex = new RegExp(regexS)
  results = regex.exec(location)
  unless results?
    ""
  else
    decodeURIComponent results[1].replace(/\+/g, " ")

#===================== delete underscored cache parameter from url parameters sequence
prepareHref = (obj) ->
  obj.attr('href', removeParameter(obj.attr('href'), '_'))

#===================== delete parameter from url parameters sequence by name
removeParameter = (url, parameter) ->
  urlparts = url.split("?")
  if urlparts.length >= 2
    urlBase = urlparts.shift()
    queryString = urlparts.join("?")
    prefix = encodeURIComponent(parameter) + "="
    pars = queryString.split(/[&;]/g)
    i = pars.length

    while i-- > 0
      pars.splice i, 1  if pars[i].lastIndexOf(prefix, 0) isnt -1
    url = urlBase + "?" + pars.join("&")
  url

#===================== init modal for the 'new' method
initNewModal = () ->
  $('#create').click ->
    newRequest()

#===================== ajax request toggled modal for the 'new' method
newRequest = () ->
  $.ajax
    type: 'GET'
    url: window.location.href + '/new'
    dataType: 'script'
    data: ''
    cache: false
    success: () ->
      $('#newModal').modal('show')

#===================== init ajax request for the delete button
initDelete = () ->
  $('#delete').click ->
    deleteConfirm()
    #deleteRequest()

deleteConfirm = () ->
  $("#delete-confirm").confirmModal
    heading: "Подтвердите удаление"
    body: "Выделенные записи будут удалены, продолжить?"
    callback: ->
      initLoadingModal()
      $('#loading').modal('show')
      deleteRequest()

#===================== ajax request for the 'destroy' method
deleteRequest = () ->
  $.ajax
    type: 'delete'
    url: window.location.href
    dataType: 'script'
    data: 'ids='+getCheckedIds()
    cache: false
    success: () ->
      tableRequest()

#===================== helper, that's return an IDs array of checked items in the data-table
getCheckedIds = () ->
  ids = []
  $('.check-row').each ->
    if $(this).hasClass('checked')
      if parseInt($(this).val()) >= 0
        ids.push($(this).val())
  return ids
	
#==================== init search top search field
initSearch = () ->
  input = $('#search-field')
  input.val(getHiddenSearch())
  input.caretToEnd()
  input.keyup ->
    delay (->
      initLoadingModal()
      $('#loading').modal('show')
      setHiddenPage(1) #search results should be shown from 1st page
      setHiddenSearch(input.val())
      tableRequest()
    ), 700

#===================  delayed function
delay = (->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
)()