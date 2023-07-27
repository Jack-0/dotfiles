# fzf options to use tokyo-storm like theme and bat syntax highlighted preview
export FZF_DEFAULT_OPTS="
    --preview '[[ -f {} ]] && bat --color=always --style=numbers --line-range=:500 {} || ls -lh ' 
    --margin 3,2
    --color=fg:-1,bg:-1,hl:#b292eb 
    --color=fg+:#ffffff,bg+:#2f3347,hl+:#2ab9d3 
    --color=info:#535b84,prompt:#759aea,pointer:#b292eb 
    --color=marker:#96c367,spinner:#af5fff,header:#ce8fff
"
