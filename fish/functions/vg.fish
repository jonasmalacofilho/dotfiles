function vg --wraps='vgrep $argv && vgrep --interactive' --description 'alias vg vgrep $argv && vgrep --interactive'
  vgrep $argv && vgrep --interactive $argv
        
end
