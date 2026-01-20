export PATH="$HOME/.local/bin:$PATH"

# vscode code
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# cpp glfw: maybe deprecate? 
export PATH="/usr/local/include/GLFW:$PATH"
export PATH="$PATH:/usr/local/include/GLFW"

export PATH="$HOME/Library/Python/3.8/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env



export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-17.0.2.jdk/Contents/Home"
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"