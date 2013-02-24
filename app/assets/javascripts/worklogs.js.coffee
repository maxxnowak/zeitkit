$ ->
  Worklog.setTimeInit()
  Worklog.autoEndTimeInit()
  SaveTime.init()
  SaveTime.updateEndTimeInit()

Worklog =
  setTimeInit: ->
    _this = this
    $('.end-time-now').on 'click touchstart', (e) ->
      e.preventDefault()
      _this.setCurrentTime()
  autoEndTimeInit: ->
    _this = this
    $('.worklog_start_time').on 'change', 'select', (e) ->
      _this.updateEndTimeStartTime($(e.currentTarget))
  setCurrentTime: ->
    current = this.getCurrentTime()
    views = this.getViews()
    _.each(views, (elem, index)->
      elem.val(current[index])
    )
  getCurrentTime: ->
    d = new Date()
    return [d.getFullYear(), d.getMonth() + 1, d.getDate(),
      d.getHours(), this.convertMinutes(d.getMinutes())]
  convertMinutes: (minutes)->
    if minutes < 10
      return "0" + minutes
    else
      return minutes
  getMonth: ->
    ["January","February","March","April","May","June",
      "July","August","September","October","November","December"]
  getViews: ->
    return [this.elems.end.year(), this.elems.end.month(), this.elems.end.day(),
      this.elems.end.hour(), this.elems.end.minute()]
  elems: {
    start: {
      all: ->
        $('.worklog_start_time select')
      year: ->
        $('#worklog_start_time_1i')
      month: ->
        $('#worklog_start_time_2i')
      day: ->
        $('#worklog_start_time_3i')
      hour: ->
        $('#worklog_start_time_4i')
      minute: ->
        $('#worklog_start_time_5i')
    }
    end: {
      all: ->
        $('.worklog_end_time select')
      year: ->
        $('#worklog_end_time_1i')
      month: ->
        $('#worklog_end_time_2i')
      day: ->
        $('#worklog_end_time_3i')
      hour: ->
        $('#worklog_end_time_4i')
      minute: ->
        $('#worklog_end_time_5i')
    }
  }
  updateEndTimeStartTime: (elem)->
    return if !elem
    end_time = this.relatedEndTime(elem)
    end_time.val(elem.val())
  relatedEndTime: (elem)->
    return $(this.elems.end.all()[elem.index()])
SaveTime =
  init: ->
    _this = this
    $('.dismiss-save-time').on 'click touchstart', (e) ->
      _this.dismissSaveTime($(e.currentTarget))
      return false
  updateEndTimeInit: ->
    _this = this
    $('.worklog_start_time').on 'change', (e) ->
      _this.updateRemote()
  updateRemote: ->
    _this = this
    $.ajax $('.update_savetime_user_path').attr('href'),
      type: 'POST'
      dataType: 'json'
      data: {
        start_time: _this.getStartTime()
      }
      error: ->
        alert "There has been an error"

  getStartTime: ->
    return new Date(Worklog.elems.start.year().val(),
      Worklog.elems.start.month().val() - 1,
      Worklog.elems.start.day().val(),
      Worklog.elems.start.hour().val(),
      Worklog.elems.start.minute().val()
    )
  dismissSaveTime: (elem)->
      url = elem.attr('href')
      $.ajax url,
        type: 'DELETE'
        dataType: 'json'
        success: ->
          $('.alert').remove()
        error: ->
          alert "There has been an error"
