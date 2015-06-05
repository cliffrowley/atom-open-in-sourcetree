spawn = require("child_process").spawn
exec  = require("child_process").exec
fs    = require("fs")

{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add "atom-workspace", "open-in-sourcetree:open", => @openApp()

  deactivate: ->
    @subscriptions.destroy()

  openApp: ->
    project_paths = atom.project?.getPaths()
    return unless project_paths.length > 0
    @openAppForDirectory(project_paths[0])

  openAppForDirectory: (project_path) ->
    switch process.platform
      when 'darwin' then @openOnMac(project_path)
      when 'win32'  then @openOnWindows(project_path)

  openOnMac: (project_path) ->
    fs.exists "/Applications/SourceTree.app", (exists) ->
      if exists
        spawn "/usr/bin/open", ["-a", "/Applications/SourceTree.app"]
      else
        spawn "/usr/bin/open", ["-a", "#{process.env['HOME']}/Applications/SourceTree.app"]

  openOnWindows: (project_path) ->
    exec "cd \"#{project_path}\" & " +
         "\"C:\\Program Files (x86)\\Atlassian\\SourceTree\\SourceTree.exe\""
