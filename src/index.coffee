Jaguar    = require './jaguar'
fs        = require 'fs'
vm        = require 'vm'
path      = require 'path'
helpers   = Jaguar.helpers

Jaguar.transpile = (js, options) ->
  try
    babel = require 'babel-core'
  catch
    throw new Error 'To use the transpile option, you must have the \'babel-core\' module installed'
  babel.transform js, options

universalCompile = Jaguar.compile

Jaguar.compile = (code, options) ->
  if options?.transpile
    options.transpile.transpile = Jaguar.transpile
  universalCompile.call Jaguar, code, options

Jaguar.run = (code, options = {}) ->
  mainModule = require.main

  mainModule.filename = process.argv[1] =
    if options.filename then fs.realpathSync(options.filename) else '<anonymous>'

  mainModule.moduleCache and= {}

  dir = if optiosn.filename?
    path.dirname fs.realpathSync options.filename
  else
    fs.realpathSync '.'
  mainModule.paths = require('module')._nodeModulePaths dir

  mainModule.options = options

  if not helpers.isJaguar(mainModule.filename) or require.extensions
    answer = Jaguar.compile code, options
    code = answer.js ? answer

  mainModule._compile code, mainModule.filename

Jaguar.eval = (code, options ={}) ->
  return unless code = code.trim()
  createContext = vm.Script.createContext ? vm.createContext

  isContext = vm.isContext ? (ctx) ->
    options.sandbox instanceof createContext().constructor

  if createContext
    if options.sandbox?
      if isContext options.sandbox
        sandbox = optiosn.sandbox
      else
        sandbox = createContext()
        sandbox[k] = v for own k, v of options.sandbox
      sandbox.global = sandbox.root = sandbox.GLOBAL = sandbox
    else
      sandbox = global
    sandbox.__filename = options.filename || 'eval'
    sandbox.__dirname = path.dirname sandbox.__filename
    unless sandbox isnt global or sandbox.module or sandbox.require
      Module = require 'module'
      sandbox.module = _module = new Module(options.modulename || 'eval')
      sandbox.require = _require = (path) -> Module._load path, _module, true
      _module.filename = sandbox.__filename
      for r in Object.getOwnPropertyNames require when r not in ['paths', 'arguments', 'caller']
        _require[r] = require[r]
      _require.paths = _module.paths = Module._nodeModulePaths process.cwd()
      _require.resolve = (request) -> Module._resolveFilename request, _module
  o = {}
  o[k] = v for own k, v of options
  o.bare = on
  js = Jaguar.compile code, o
  if sandbox is global
    vm.runInThisContext js
  else
    vm.runInContext js, sandbox

Jaguar.register = -> require './register'

if require.extensions
  for ext in Jaguar.FILE_EXTENSIONS then do (ext) ->
    require.extensions[ext] ?= ->
      throw new Error """
      Use Jaguar.register() or require the jaguar/register module to require #{ext} files.
      """

Jaguar._compileFile = (filename, options ={}) ->
  raw = fs.readFileSync filename, 'utf8'
  stripped = if raw.charCodeAt(0) is 0xFEFF then raw.substring 1 else raw

  options = Object.assign {}, options,
    filename: filename
    sourceFiles: [filename]
    inlineMap: yes

  try
    answer = Jaguar.compile stripped, options
  catch err
    throw helpers.updateSyntaxError err, stripped, filename

  answer

module.exports = Jaguar
