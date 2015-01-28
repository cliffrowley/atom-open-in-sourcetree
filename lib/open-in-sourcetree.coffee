
module.exports =
  activate: (state) ->
    atom.workspaceView.command "open-in-sourcetree:open", => @openApp()

  openApp: ->
    if (path = atom.project?.getPath())?
      
      cmd = if process.platform is 'win32'
        "cd \"#{path}\" & " +
          "\"C:\\Program Files (x86)\\Atlassian\\SourceTree\\SourceTree.exe\""
      else
        "open -a SourceTree.app #{path}"
        
      # requiring here saves some time at load
      require("child_process").exec cmd
