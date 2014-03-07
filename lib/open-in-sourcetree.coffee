exec = require("child_process").exec

module.exports =
  activate: (state) ->
    atom.workspaceView.command "open-in-sourcetree:open", => @openApp()

  openApp: ->
    path = atom.project?.getPath()
    exec "open -a SourceTree.app #{path}" if path?
