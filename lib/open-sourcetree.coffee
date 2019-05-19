spawn = require('child_process').spawn
exec  = require('child_process').exec
fs    = require('fs')

openOnMac = (projectPath) ->
  appBundleIndentifier = 'com.torusknot.SourceTreeNotMAS'
  spawn '/usr/bin/open', ['-b', appBundleIndentifier, projectPath]

openOnLinux = (projectPath) ->
  atom.notifications.addInfo 'Open in SourceTree',
    detail: 'No Sourcetree on Linux yet'

openOnWindows = (projectPath) ->
  execpath = "\"%LOCALAPPDATA%\\SourceTree\\SourceTree.exe\" -f \"#{projectPath}\""

  # Add notification
  atom.notifications.addInfo 'Open in SourceTree',
    detail: execpath

  exec execpath
  # exec "cd \"#{projectPath}\" & " +
  # "\"C:\\Program Files (x86)\\Atlassian\\SourceTree\\SourceTree.exe\""

openAppForDirectory = (projectPath) ->
  switch process.platform
    when 'darwin' then openOnMac(projectPath)
    when 'win32'  then openOnWindows(projectPath)
    when 'linux'  then openOnLinux(projectPath)

module.exports = openAppForDirectory
