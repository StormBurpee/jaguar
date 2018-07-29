fs                        = require 'fs'
os                        = require 'os'
path                      = require 'path'
_                         = require 'underscore'
{ spawn, exec, execSync } = require 'child_process'
Jaguar                    = require './lib/jaguar'
helpers                   = require './lib/jaguar/helpers'

# ANSI Terminal Colors.
bold = red = green = yellow = reset = ''
unless process.env.NODE_DISABLE_COLORS
  bold   = '\x1B[0;1m'
  red    = '\x1B[0;31m'
  green  = '\x1B[0;32m'
  yellow = '\x1B[0;33m'
  reset  = '\x1B[0m'

header = """
  /**
   * Jaguar Compiler vIMPLEMENT
   * https://jaguar-lang.io
   *
   * Copyright 2018, Storm Burpee
   * Released under the MIT License
   */
"""

log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

spawnNodeProcess = (args, output = 'stderr', callback) ->
  relayOutput = (buffer) -> console.log buffer.toString()
  proc = spawn 'node', args
  proc.stdout.on 'data', relayOutput if output is 'both' or output is 'stdout'
  proc.stderr.on 'data', relayOutput if output is 'both' or output is 'stderr'
  proc.on 'exit', (status) -> callback(status) if typeof callback is 'function'

spawnCoffeeProcess = (args, output = 'stderr', callback) ->
  relayOutput = (buffer) -> console.log buffer.toString()
  proc = spawn 'coffee', args
  proc.stdout.on 'data', relayOutput if output is 'both' or output is 'stdout'
  proc.stderr.on 'data', relayOutput if output is 'both' or output is 'stderr'
  proc.on 'exit', (status) -> callback(status) if typeof callback is 'function'

run = (args, callback) ->
  spawnCoffeeProcess args, 'stderr', (status) ->
    process.exit(1) if status isnt 0
    callback() if typeof callback is 'function'

buildParser = ->
  helpers.extend global, require 'util'
  require 'jison'
  parser = require('./lib/jaguar/grammar').parser.generate(moduleMain: ->)
  fs.writeFileSync './lib/jaguar/parser.js', parser

buildExceptParser = (callback) ->
  files = fs.readdirSync 'src'
  files = ('src/' + file for file in files when file.match(/\.coffee$/))
  run ['-c', '-o', 'lib/jaguar'].concat(files), callback

build = (callback) ->
  buildParser()
  buildExceptParser callback

task 'build', 'build the Jaguar compiler from source', build
task 'build:parser', 'build the Jison parser only', buildParser
task 'build:except-parser', 'build the Jaguar compiler, except for the parser', buildExceptParser
