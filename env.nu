use std

def to_right_powerline_style [main_color, font_color] {
    let start = $'(ansi --escape {fg: $main_color attr: r})(ansi reset)'
    let end = $'(ansi --escape {fg: $main_color})(ansi reset)'
    if $in == '' {
        return ($start + $end)
    }
    let body = $'(ansi --escape {fg: $font_color, bg: $main_color}) ($in) (ansi reset)'

    $start + $body + $end
}

def to_left_powerline_style [main_color, font_color] {
    let start = $'(ansi --escape {fg: $main_color})(ansi reset)'
    let end = $'(ansi --escape {fg: $main_color attr: r})(ansi reset)'
    if $in == '' {
        return ($start + $end)
    }
    let body = $'(ansi --escape {fg: $font_color, bg: $main_color}) ($in) (ansi reset)'

    $start + $body + $end
}

def create_user_prompt [] {
    let user = whoami
    let host = hostname
    $'(ansi white)($user)@($host)(ansi reset)'
}

def create_dir_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }
    $dir | to_right_powerline_style '#79B8FF' '#19191A'
}

def create_git_prompt [] {
    let git_dir = $env.PWD | path join '.git'
    let branch = if ($git_dir | path exists) {
        git branch --show-current | $' ' + $in
    } else ''
    $branch | to_right_powerline_style '#95FFA4' '#19191A'
}

def create_mem_prompt [] {
    let total_mem = sys mem | get total
    let used_mem = sys mem | get used
    let mem = if $used_mem / $total_mem > 0.5 {
        $used_mem | into string
    } else ''
    $mem | to_right_powerline_style '#FFC073' '#19191A'
}

def create_time_prompt [] {
    let time = (date now | format date '%H:%M:%S')
    let duration_ms = $env.CMD_DURATION_MS | into int
    let duration = if $duration_ms < 1000 {
        $'($duration_ms)ms'
    } else $'($duration_ms / 1000)s'
    $time + ' ' + $duration | to_left_powerline_style '#7160E8' '#EBEDF2'
}

def create_exit_code_prompt [] {
    let last_exit_code = $env.LAST_EXIT_CODE
    if $last_exit_code != 0 {
        $'(ansi --escape { fg : "#F97583" })($last_exit_code)(ansi reset)'
    } else null
}

def create_left_prompt [] {
    let user = create_user_prompt
    let dir = create_dir_prompt
    let git = create_git_prompt
    let mem = create_mem_prompt
    '  ' + $user + ' ' + $dir + $git + $mem + "\n\n"
}

def create_right_prompt [] {
    let exit_code = create_exit_code_prompt
    let time = create_time_prompt
    [$time, $exit_code] | str join ' '
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }
$env.PROMPT_INDICATOR = {|| "❯ " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "❯ " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')
