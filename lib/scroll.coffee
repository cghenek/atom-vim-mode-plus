class Scroll
  isComplete: -> true
  isRecordable: -> false
  constructor: (@editorElement) ->
    @scrolloff = 2 # atom default
    @editor = @editorElement.getModel()
    @rows =
      first: @editorElement.getFirstVisibleScreenRow()
      last: @editorElement.getLastVisibleScreenRow()
      final: @editor.getLastScreenRow()

class ScrollDown extends Scroll
  execute: (count=1) ->
    @keepCursorOnScreen(count)
    @scrollUp(count)

  keepCursorOnScreen: (count) ->
    {row, column} = @editor.getCursorScreenPosition()
    firstScreenRow = @rows.first + @scrolloff + 1
    if row - count <= firstScreenRow
      @editor.setCursorScreenPosition([firstScreenRow + count, column])

  scrollUp: (count) ->
    lastScreenRow = @rows.last - @scrolloff
    @editor.scrollToScreenPosition([lastScreenRow + count, 0])

class ScrollUp extends Scroll
  execute: (count=1) ->
    @keepCursorOnScreen(count)
    @scrollDown(count)

  keepCursorOnScreen: (count) ->
    {row, column} = @editor.getCursorScreenPosition()
    lastScreenRow = @rows.last - @scrolloff - 1
    if row + count >= lastScreenRow
      @editor.setCursorScreenPosition([lastScreenRow - count, column])

  scrollDown: (count) ->
    firstScreenRow = @rows.first + @scrolloff
    @editor.scrollToScreenPosition([firstScreenRow - count, 0])

class ScrollCursor extends Scroll
  constructor: (@editor, @opts={}) ->
    super
    cursor = @editor.getCursorScreenPosition()
    @pixel = @editor.pixelPositionForScreenPosition(cursor).top

class ScrollCursorToTop extends ScrollCursor
  execute: ->
    @moveToFirstNonBlank() unless @opts.leaveCursor
    @scrollUp()

  scrollUp: ->
    return if @rows.last is @rows.final
    @pixel -= (@editor.getLineHeightInPixels() * @scrolloff)
    @editor.setScrollTop(@pixel)

  moveToFirstNonBlank: ->
    @editor.moveToFirstCharacterOfLine()

class ScrollCursorToMiddle extends ScrollCursor
  execute: ->
    @moveToFirstNonBlank() unless @opts.leaveCursor
    @scrollMiddle()

  scrollMiddle: ->
    @pixel -= (@editor.getHeight() / 2)
    @editor.setScrollTop(@pixel)

  moveToFirstNonBlank: ->
    @editor.moveToFirstCharacterOfLine()

class ScrollCursorToBottom extends ScrollCursor
  execute: ->
    @moveToFirstNonBlank() unless @opts.leaveCursor
    @scrollDown()

  scrollDown: ->
    return if @rows.first is 0
    offset = (@editor.getLineHeightInPixels() * (@scrolloff + 1))
    @pixel -= (@editor.getHeight() - offset)
    @editor.setScrollTop(@pixel)

  moveToFirstNonBlank: ->
    @editor.moveToFirstCharacterOfLine()

module.exports = {ScrollDown, ScrollUp, ScrollCursorToTop, ScrollCursorToMiddle,
  ScrollCursorToBottom}
