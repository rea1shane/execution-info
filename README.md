# rea1shane/execution-info

> [!NOTE]
>
> This repo is a fork of the Zim official module [duration-info](https://github.com/zimfw/duration-info).

Exposes to prompts how long the last command took to execute,
and the start and end time of the execution.

## Settings

By default, the duration information will be only set if the command took at
least 2 seconds to execute. The threshold value, in seconds, can be customized
with:

```shell
zstyle ':zim:execution-info' duration-threshold <threshold value> # default: 2
```

The threshold value can be a decimal number.

## Theming

### Start and end time

To configure the format of the start or end information, use the following syntax in
your prompt code:

```shell
zstyle ':zim:execution-info' start-format '<date format string>' # default: '%Y-%m-%d %H:%M:%S'
zstyle ':zim:execution-info' end-format '<date format string>' # default: '%Y-%m-%d %H:%M:%S'
```

The module will use GNU date or BSD date (depending on the version of date in the environment) to format the time according to the format string.
and the `execution_start_info` and `ecction_end_info` variables are set to formatted strings respectively.

### Duration

To configure the format of the duration information, use the following syntax in
your prompt code:

```shell
zstyle ':zim:execution-info' duration-format '<string containing %d>' # default: '%d'
```

The occurrence of the `%d` code in the format string is substituted by the
duration, and the `execution_duration_info` variable is set to the formatted string.

The content of `%d`:

| Case               | Format          | Example  |
| ------------------ | --------------- | -------- |
| 1h =< duration     | `${h}h ${m}m`   | `1h 2m`  |
| 1m =< duration <1h | `${m}m ${s}s`   | `1m 2s`  |
| 1s =< duration <1m | `${s}s ${ms}ms` | `1s 2ms` |
| duration <1s       | `${ms}ms`       | `2ms`    |

If the duration is less than the threshold, the variable is unset instead.

## Usage

Add following contents in your prompt code. Usually, you'll add it to the value of either `PS1` or `RPS1`.

- Add `${execution_start_info}` to where you want the start time information to be displayed.
- Add `${execution_end_info}` to where you want the end time information to be displayed.
- Add `${execution_duration_info}` to where you want the duration information to be displayed.

Also, add the `execution-info-preexec` and `execution-info-precmd`
functions to the preexec and precmd hooks respectively.

Here's an example:

```zsh
setopt nopromptbang prompt{cr,percent,sp,subst}

zstyle ':zim:execution-info' duration-threshold 0.5
zstyle ':zim:execution-info' start-format       'executed at %Y-%m-%d %H:%M:%S'
zstyle ':zim:execution-info' end-format         ', finished at %Y-%m-%d %H:%M:%S'
zstyle ':zim:execution-info' duration-format    ', took %d'

autoload -Uz add-zsh-hook
add-zsh-hook preexec execution-info-preexec
add-zsh-hook precmd  execution-info-precmd

RPS1='${execution_start_info}${execution_end_info}${execution_duration_info}'
```
