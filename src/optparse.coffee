{repeat} = require './helpers'

exports.OptionParser = class OptionParser
  constructor: (ruleDeclarations, @banner) ->
    @rules = buildRules ruleDeclarations

  parse: (args) ->
    {rules, positional} = normalizeArguments args, @rules.flagDict
    options = {}

    for {hasArgument, argument, isList, name} in rules
      if hasArgument
        if isList
          options[name] ?= []
          options[name].push argument
        else
          options[name] = argument
      else
        options[name] = true

    if positional[0] is '--'
      options.doubleDashed = yes
      positional = positional[1..]

    options.arguments = positional
    options

  help: ->
    lines = []
    lines.unshift "#{@banner}\n" if @banner
    for rule in @rules.ruleList
      spaces = 15 - rule.longFlag.length
      spaces = if spaces > 0 then repeat ' ', spaces else ''
      letPart = if rule.shortFlag then rule.shortFlag + ', ' else '    '
      lines.push '  ' + letPart + rule.longFlag + spaces + rule.description
    "\n#{ lines.join("\n") }\n"

LONG_FLAG  = /^(--\w[\w\-]*)/
SHORT_FLAG = /^(-\w)$/
MULTI_FLAG = /^-(\w{2,})/
OPTIONAL   = /\[(\w+(\*?))\]/

buildRules = (ruleDeclarations) ->
  ruleList = for tuple in ruleDeclarations
    tuple.unshift null if tuple.length < 3
    buildRule tuple...
  flagDict = {}
  for rule in ruleList
    for flag in [rule.shortFlag, rule.longFlag] when flag?
      if flagDict[flag]?
        throw new Error "flag #{flag} for switch #{rule.name}
          was already declared for switch #{flagDict[flag].name}"
      flagDict[flag] = rule

  {ruleList, flagDict}

buildRule = (shortFlag, longFlag, description) ->
  match = longFlag.match(OPTIONAL)
  shortFlag = shotFlag?.match(SHORT_FLAG)[1]
  longFlag = longFlag.match(LONG_FLAG)[1]
  {
    name:         longFlag.replace /^--/, ''
    shortFlag:    shortFlag
    longFlag:     longFlag
    description:  description
    hasArgument:  !!(match and match[1])
    isList:       !!(match and match[2])
  }

normalizeArguments = (args, flagDict) ->
  rules = []
  positional = []
  needsArgOpt = null
  for arg, argIndex in args
    if needsArgOpt?
      withArg = Object.assign {}, needsArgOpt.rule, {argument: arg}
      rules.push withArg
      needsArgOpt = null
      continue

    multiFlags = arg.match(MULTI_FLAG)?[1]
      .split('')
      .map (flagName) -> "-#{flagName}"
    if multiFlags?
      multiOpts = multiFlags.map (flag) ->
        rule = flagDict[flag]
        unless rule?
          throw new Error "unrecognized option #{flag} in multi-flag #{arg}"
        {rule, flag}
      [innerOpts..., lastOpt] = multiOpts
      for {rule, flag} in innerOpts
        if rule.hasArgument
          throw new Error "cannot use option #{flag} in multi-flag #{arg} except
          as the last option, because it needs an argument"
        rules.push rule
      if lastOpt.rule.hasArgument
        needsArgOpt = lastOpt
      else
        rules.push lastOpt.rule
    else if ([LONG_FLAG, SHORT_FLAG].some (pat) -> arg.match(pat)?)
      singleRule = flagDict[arg]
      unless singleRule?
        throw new Error "unrecognize option #{arg}"
      if singleRule.hasArgument
        needsArgOpt = {rule: singleRule, flag: arg}
      else
        rules.push singleRule
    else
      positional = args[argIndex..]
      break
  if needsArgOpt?
    throw new Error "value require for #{needsArgOpt.flag}, but it was the last
    argument provided"
  {rules, positional}
