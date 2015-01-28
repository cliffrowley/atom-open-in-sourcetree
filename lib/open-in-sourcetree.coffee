spawn = require("child_process").spawn
fs    = require("fs")

module.exports =
  activate: (state) ->
    atom.workspaceView.command "open-in-sourcetree:open", => @openApp()

  openApp: ->
    project_path = atom.project?.getPath()
    return unless project_path?
    @openApp2 project_path, [ "/Applications", "#{process.env['HOME']}/Applications" ]

  openApp2: (project_path, app_paths = []) ->
    if app_paths?.length > 0
      child = spawn "/usr/bin/open", ["-a", "#{app_paths[0]}/SourceTree.app", project_path]
      child.on 'close', (code) =>
        app_paths = [].concat(app_paths[1..])
        @openApp2(project_path, app_paths) if code > 0 and app_paths.length > 0
