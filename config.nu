use std/dirs

$env.config.buffer_editor = "code"
$env.config.completions.external.completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}
$env.config.show_banner = false
