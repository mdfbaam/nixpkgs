if [[ -z "${__nix_deployQtWinPluginsHook-}" ]]; then
    __nix_deployQtWinPluginsHook=1 # Don't run this hook more than once.

    qtPluginPath="@qtPluginPath@"

    deployQt() {
        # Check if already deployed
        local targetDir=$(dirname "$1")

        echo "qtPluginPath: $qtPluginPath"

        for pluginDir in $qtPluginPath/*/; do
            local targetPluginDir="$targetDir/$(basename $pluginDir)"

            if ! [ -L "$targetPluginDir" ]; then
                echo "Linking Qt plugins at $targetPluginDir"
                ln -s $pluginDir $targetPluginDir
            fi
        done
    }

    deployQtWinPluginsHook() {
        # skip this hook when requested
        [ -z "${dontDeployQtWinPlugins-}" ] || return 0

        # guard against running multiple times (e.g. due to propagation)
        [ -z "$deployQtWinPluginsHookHasRun" ] || return 0
        deployQtWinPluginsHookHasRun=1

        local targetDirs=("$prefix/bin" "$prefix/sbin" "$prefix/libexec" "$prefix/Applications" "$prefix/"*.app)
        echo "deploying plugins for Qt applications in ${targetDirs[@]}"

        for targetDir in "${targetDirs[@]}"; do
            [ -d "$targetDir" ] || continue

            find "$targetDir" ! -type d -executable -print0 | while IFS= read -r -d '' file; do
                if [ -f "$file" ]; then
                    echo "deploying for $file"
                    deployQt "$file"
                fi
            done
        done
    }

    fixupOutputHooks+=(deployQtWinPluginsHook)
fi
