gitmodule = {name: "gitmodule"}

#region modulesFromEnvironment
#region node_modules
git = require "simple-git/promise"
#endregion

#region localModules
globalScope = null
#endregion
#endregion

#region logPrintFunctions
##############################################################################
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["gitmodule"]?  then console.log "[gitmodule]: " + arg
    return
#endregion
##############################################################################
gitmodule.initialize = () ->
    log "gitmodule.initialize"
    globalScope = allModules.globalscopemodule
    return
    
#region internalFunctions
#endregion

#region exposedFunctions
gitmodule.addSubmodule = (base, remote, label) ->
    log "gitmodule.addSubmodule"
    url = remote.getSSH()
    if !url or !globalScope.repoIsInScope(remote.getRepo()) 
        url = remote.getHTTPS()
    await git(base).submoduleAdd(url, label)
    return

gitmodule.push = (base) ->
    log "gitmodule.push"
    await git(base).push("origin", "master")
    return

gitmodule.addAll = (base) ->
    log "gitmodule.addAll"
    await git(base).add(".")
    return

gitmodule.init = (base, remote) ->
    log "gitmodule.init"
    await git(base).init()
    await git(base).addRemote("origin", remote.getSSH())
    return

gitmodule.addPush = (base, remote) ->
    log "gitmodule.addPush"
    await gitmodule.addAll(base)
    await git(base).commit("initial commit")
    await gitmodule.push(base)
    return

gitmodule.initPush = (base, remote) ->
    log "gitmodule.initAndPush"
    await gitmodule.init(base,remote)
    await gitmodule.addAll(base)
    await git(base).commit("initial commit")
    await gitmodule.push(base)
    return

gitmodule.clone = (remote, base) ->
    log "gitmodule.clone"
    url = remote.getSSH()
    if !url or !globalScope.repoIsInScope(remote.getRepo()) 
        url = remote.getHTTPS()
    if !url then throw "No URL to clone available for RemoteObject!"
    await git(base).clone(url)
    return
#endregion

module.exports = gitmodule