class ScopedConfig
  constructor: (@scope, @config) ->

  get: (param) ->
    if param is 'defaultRegister'
      if @get('useClipboardAsDefaultRegister') then '*' else '"'
    else
      atom.config.get "#{@scope}.#{param}"

  set: (param, value) ->
    atom.config.set "#{@scope}.#{param}", value

module.exports = new ScopedConfig 'vim-mode',
  startInInsertMode:
    order: 1
    type: 'boolean'
    default: false
  useSmartcaseForSearch:
    order: 2
    type: 'boolean'
    default: false
  wrapLeftRightMotion:
    order: 3
    type: 'boolean'
    default: false
  useClipboardAsDefaultRegister:
    order: 4
    type: 'boolean'
    default: false
  numberRegex:
    order: 5
    type: 'string'
    default: '-?[0-9]+'
    description: 'Use this to control how Ctrl-A/Ctrl-X finds numbers; use "(?:\\B-)?[0-9]+" to treat numbers as positive if the minus is preceded by a character, e.g. in "identifier-1".'
  debug:
    order: 6
    type: 'boolean'
    default: false
  debugOutput:
    order: 7
    type: 'string'
    default: 'console'
    enum: ['console', 'file']
