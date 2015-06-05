spawn = require('child_process').spawn
exec  = require('child_process').exec
fs    = require('fs')

{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'open-in-sourcetree:open', => @openApp()

  deactivate: ->
    @subscriptions.destroy()

  notifyError: (title, detail) ->
    atom.notifications.addError title, detail: detail, dismissable: true

  notifyInfo: (title, detail) ->
    atom.notifications.addInfo title, detail: detail, dismissable: true

  openApp: ->
    projectPaths = atom.project?.getPaths()

    if projectPaths.length is 0
      @notifyInfo 'Open in SourceTree', 'This project has no paths, that\'s weird.'
    else if projectPaths.length is 1
      @openAppForDirectory projectPaths[0]
    else
      @notifyError 'Open in SourceTree', 'Sorry, multiple project dirs will be supported soon!'

  openAppForDirectory: (projectPath) ->
    switch process.platform
      when 'darwin' then @openOnMac(projectPath)
      when 'win32'  then @openOnWindows(projectPath)

  openOnMac: (projectPath) ->
    fs.exists '/Applications/SourceTree.app', (exists) ->
      if exists
        spawn '/usr/bin/open', ['-a', '/Applications/SourceTree.app']
      else
        spawn '/usr/bin/open', ['-a', "#{process.env['HOME']}/Applications/SourceTree.app"]

  openOnWindows: (projectPath) ->
    exec "cd \"#{projectPath}\" & " +
         "\"C:\\Program Files (x86)\\Atlassian\\SourceTree\\SourceTree.exe\""
