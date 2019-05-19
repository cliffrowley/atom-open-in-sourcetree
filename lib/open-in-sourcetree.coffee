fs = require('fs')
path = require('path')

{CompositeDisposable} = require 'atom'
ProjectPathListView = require './project-path-list-view'

getActiveFilePath = () ->
  document.querySelector('.tree-view .selected')?.getPath?() ||
    atom.workspace.getActivePaneItem()?.buffer?.file?.path

findGitRoot = (dirpath, origpath = dirpath) ->
  if fs.existsSync(path.join(dirpath, '.git'))
    return dirpath

  parentDirpath = path.dirname(dirpath)
  if (parentDirpath == dirpath or parentDirpath == '.')
    return origpath # Give option to create a Git repo if none found
  return findGitRoot(parentDirpath, origpath)

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
        'open-in-sourcetree:open', (e) => @openApp(e)

  deactivate: ->
    @subscriptions.destroy()

  # openApp: ->
  openApp: (e) ->
    e.stopImmediatePropagation()

    filepath = @getPath?() || @getModel?().getPath?() || getActiveFilePath()

    try
      isFile = fs.lstatSync(fs.realpathSync(filepath)).isFile()
    catch
      isFile = true
    if isFile
      dirpath = path.dirname(filepath)
    else
      dirpath = filepath

    return if not dirpath

    gitroot = findGitRoot(dirpath)

    require('./open-sourcetree')(gitroot)
