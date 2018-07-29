Jaguar = require './'
child_process = require 'child_process'
helpers = require './helpers'
path = require 'path'

loadFile = (module, filename) ->
  options = module.options or getRootModule(module).options
  answer = Jaguar._compileFile filename, options
  module._compile answer, filename

if require.extensions
  for ext in Jaguar.FILE_EXTENSIONS
    require.extensions[ext] = loadFile

  Module = require 'module'

  findExtension = (filename) ->
    extensions = path.basename(filename).split '.'
    extensions.shift() if extensions[0] is ''
    while extensions.shift()
      curExtension = '.' + extensions.join '.'
      return curExtension if Module._extensions[curExtension]
    '.js'

  Module::load = (filename) ->
    @filename = filename
    @paths = Module._nodeModulePaths path.dirname filename
    extension = findExtension filename
    Module._extensions[extension](this, filename)
    @loaded = true

if child_process
  {fork} = child_process
  binary = require.resolve '../../bin/jaguar'
  child_process.fork = (path, args, options) ->
    if helpers.isJaguar path
      unless Array.isArray args
        options = args or {}
        args = []
      args = [path].concat args
      path = binary
    fork path, args, options

getRootModule = (module) ->
  if module.parent then getRootModule module.parent else module
