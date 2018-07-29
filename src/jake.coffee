fs = require 'fs'
path = require 'path'
helpers = require './helpers'
optparse = require './optparse'
Jaguar = require './'

Jaguar.register()

tasks = {}
options = {}
switches = {}
oparse = null

helpers.extend global,
  task: (name, description, action) ->
    [action, description] = [description, action] unless action
    tasks[name] = {name, description, action}

  option: (letter, flag, description) ->
    switches.push [letter, flag, description]

  invoke: (name) ->
    missingTask name unless tasks[name]
    tasks[name].action options

exports.run = ->
  global.__originalDirname = fs.realpathSync '.'
  process.chdir jakefileDirectory __originalDirname
  args = process.argv[2..]
  Jaguar.run fs.readFileSync('Jakefile').toString(), filename: 'Jakefile'
  oparse = new optparse.OptionParser switches
  return printTasks() unless args.length
  try
    options = oparse.parse(args)
  catch e
    return fatalError "#{e}"
  invoke arg for arg in options.arguments

printTasks = ->
  relative = path.relative or path.resolve
  jakefilePath = path.join relative(__originalDirname, process.cwd()), 'Jakefile'
  console.log "#{jakefilePath} defines the following tasks:\n"
  for name, task of tasks
    spaces = 20 - name.length
    spaces = if spaces > 0 then Array(spaces + 1).join(' ') else ''
    desc = if task.description then "# #{task.description}" else ''
    console.log "jake #{name}#{spaces} #{desc}"
  console.log oparse.help() if switches.length

fatalError = (message) ->
  console.error message + '\n'
  console.log 'To see a list of all tasks/options, run "jake"'
  process.exit 1

missingTask = (task) -> fatalError "No such task: #{task}"

jakefileDirectory = (dir) ->
  return dir if fs.existsSync path.join dir, 'Jakefile'
  parent = path.normalize path.join dir, '..'
  return jakefileDirectory parent unless parent is dir
  throw new Error "Jakefile not found in #{process.cwd()}"
