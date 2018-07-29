exports.Scope = class Scope
  constructor: (@parents, @expressions, @method, @referencedVars) ->
    @variables = [{name: 'arguments', type: 'arguments'}]
    @comments = {}
    @positions = {}
    @utilities = {} unless @parent

    @root = @parent?.root ? this

  add: (name, type, immediate) ->
    return @parent.add name, type, immediate if @shared and not immediate
    if Object::hasOwnProperty.call @positions, name
      @variables[@positions[name]].type = type
    else
      @positions[name] = @variables.push({name, type}) - 1

  namedMethod: ->
    return @method if @method?.name or !@parent
    @parent.namedMethod()

  find: (name, type = 'var') ->
    return yes if @check name
    @add name, type
    no

  parameter: (name) ->
    return if @shared and @parent.check name, yes
    @add name, 'param'

  check: (name) ->
    !!(@type(name) or @parent?.check(name))

  temporary: (name, index, single=false) ->
    if single
      startcode = name.charCodeAt(0)
      endCode = 'z'.charCodeAt(0)
      diff = endCode - startcode
      newCode = startCode + index % (diff + 1)
      letter = String.fromCharCode(newCode)
      num = index // (diff + 1)
      "#{letter}#{num or ''}"
    else
      "#{name}#{index or ''}"

  type: (name) ->
    return v.type for v in @variables when v.name is name
    null

  freeVariable: (name, options={}) ->
    index = 0
    loop
      temp = @temporary name, index, options.single
      break unless @check(temp) or temp in @root.referencedVars
      index++
    @add temp, 'var', yes if options.reserve ? true
    temp

  assign: (name, value) ->
    @add name, {value, assigned: yes}, yes
    @hasAssignments = yes

  hasDeclarations: ->
    !!@declaredVariables().length

  declaredVariables: ->
    (v.name for v in @variables when v.type is 'var').sort()

  assignedVariables: ->
    "#{v.name} = #{v.type.value}" for v in @variables when v.type.assigned
