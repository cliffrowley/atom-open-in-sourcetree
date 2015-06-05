
module.exports =
  activate: (state) ->
    atom.workspaceView.command "open-in-sourcetree:open", => @openApp()

  openApp: ->
    project_path = atom.project?.getPath()
    return unless project_path?
    
    if process.platform is 'win32'
      require("child_process").exec "cd \"#{project_path}\" & " +
                    "\"C:\\Program Files (x86)\\Atlassian\\SourceTree\\SourceTree.exe\""
    else
      @openApp2 project_path, [ "/Applications", "#{process.env['HOME']}/Applications" ]

  openApp2: (project_path, app_paths = []) ->
    if app_paths?.length > 0
      child = require("child_process").spawn "/usr/bin/open", 
                        ["-a", "#{app_paths[0]}/SourceTree.app", project_path]
      child.on 'close', (code) =>
        app_paths = [].concat(app_paths[1..])
        @openApp2(project_path, app_paths) if code > 0 and app_paths.length > 0
