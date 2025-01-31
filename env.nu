use std

module prompt {
    const vetus = {
        black: '#19191A',
        white: '#EBEDF2',
        blue: '#79B8FF',
        green: '#95FFA4',
        yellow: '#FFC073',
        red: '#F97583',
        purple: '#7160E8'
    }

    def to_ansi [style] {
        $'($style)($in)(ansi reset)'
    }

    def to_right_powerline_style [main_color, font_color] {
        let start = "" | to_ansi (ansi --escape {fg: $main_color attr: r})
        let end = "" | to_ansi (ansi --escape {fg: $main_color})
        if $in == '' {
            return ($start + $end)
        }
        let body = $" ($in) " | to_ansi (ansi --escape {fg: $font_color, bg: $main_color})
        $start + $body + $end
    }

    def to_left_powerline_style [main_color, font_color] {
        let start = "" | to_ansi (ansi --escape {fg: $main_color})
        let end = "" | to_ansi (ansi --escape {fg: $main_color attr: r})
        if $in == '' {
            return ($start + $end)
        }
        let body = $" ($in) " | to_ansi (ansi --escape {fg: $font_color, bg: $main_color})
        $start + $body + $end
    }

    def create_user_prompt [] {
        let user = whoami
        let host = hostname -s
        $'($user)@($host)' | to_ansi (ansi default)
    }

    def create_dir_prompt [] {
        let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
            null => $env.PWD
            '' => '~'
            $relative_pwd => ([~ $relative_pwd] | path join)
        }
        $dir | to_right_powerline_style $vetus.blue $vetus.black
    }

    def create_git_prompt [] {
        let ret = git branch --show-current | complete
        if $ret.exit_code == 0 {
            $" ($ret.stdout | str trim)"
        } else {
            ''
        } | to_right_powerline_style $vetus.green $vetus.black
    }

    def create_mem_prompt [] {
        let total_mem = sys mem | get total
        let used_mem = sys mem | get used
        if $used_mem / $total_mem > 0.5 {
            $used_mem | into string
        } else {
            ''
        } | to_right_powerline_style $vetus.purple $vetus.white
    }

    def create_time_prompt [] {
        let time = (date now | format date '%H:%M:%S')
        let duration_ms = $env.CMD_DURATION_MS | into int
        let duration = if $duration_ms < 1000 {
            $'($duration_ms)ms'
        } else $'($duration_ms / 1000)s'
        $time + ' ' + $duration | to_left_powerline_style $vetus.yellow $vetus.black
    }

    def create_exit_code_prompt [] {
        let last_exit_code = $env.LAST_EXIT_CODE
        if $last_exit_code != 0 {
            $last_exit_code | to_ansi (ansi --escape { fg : $vetus.red })
        } else ''
    }

    export def create_left_prompt [] {
        let user = create_user_prompt
        let dir = create_dir_prompt
        let git = create_git_prompt
        let mem = create_mem_prompt
        '  ' + $user + ' ' + $dir + $git + $mem + "\n\n"
    }

    export def create_right_prompt [] {
        let exit_code = create_exit_code_prompt
        let time = create_time_prompt
        if $exit_code != '' {
            $time + ' ' + $exit_code
        } else $time
    }
}

use prompt
$env.PROMPT_COMMAND = {|| prompt create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| prompt create_right_prompt }
$env.PROMPT_INDICATOR = {|| '❯ ' }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ': ' }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| '❯ ' }
$env.PROMPT_MULTILINE_INDICATOR = {|| '::: ' }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
# $env.ENV_CONVERSIONS = {
#     "PATH": {
#         from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
#         to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
#     }
#     "Path": {
#         from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
#         to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
#     }
# }

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
