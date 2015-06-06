spawn = require('child_process').spawn
exec  = require('child_process').exec
fs    = require('fs')

openOnMac = (projectPath) ->
  appPath = '/Applications/SourceTree.app'

  fs.exists appPath, (exists) ->
    if exists
      spawn '/usr/bin/open', ['-a', appPath, projectPath]
    else
      spawn '/usr/bin/open', ['-a', "#{process.env['HOME']}#{{appPath}}", projectPath]

openOnWindows = (projectPath) ->
  exec "cd \"#{projectPath}\" & " +
       "\"C:\\Program Files (x86)\\Atlassian\\SourceTree\\SourceTree.exe\""

openAppForDirectory = (projectPath) ->
  switch process.platform
    when 'darwin' then openOnMac(projectPath)
    when 'win32'  then openOnWindows(projectPath)

module.exports = openAppForDirectory
