{Lexer} = require './lexer'
{parser} = require './parser'
helpers = require './helpers'
SourceMap = require './sourcemap'
packageJson = require '../../package.json'

exports.VERSION = packageJson.version
exports.FILE_EXTENSIONS = FILE_EXTENSIONS = ['.jag', '.jaguar', '.litjag', '.litjaguar']
