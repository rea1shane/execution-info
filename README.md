duration-info
=============

> [!IMPORTANT]
>
> The following changes have been made based on the original version:
>
> 1. Disabled features:
>    1. Flag `':zim:duration-info' show-milliseconds`.
>    1. If the threshold value is less than 1, then milliseconds are automatically shown.
> 1. Redesign the content of `%d`:
>    | When               | Format          | Example  |
>    | ------------------ | --------------- | -------- |
>    | 1h =< duration     | `${h}h ${m}m`   | `1h 2m`  |
>    | 1m =< duration <1h | `${m}m ${s}s`   | `1m 2s`  |
>    | 1s =< duration <1m | `${s}s ${ms}ms` | `1s 2ms` |
>    | duration <1s       | `${ms}ms`       | `2ms`    |

Exposes to prompts how long the last command took to execute.

Settings
--------

By default, the duration information will be only set if the command took at
least 2 seconds to execute. The threshold value, in seconds, can be customized
with:

    zstyle ':zim:duration-info' threshold <threshold value>

The threshold value can be a decimal number. ~~If the threshold value is less than
1, then milliseconds are automatically shown.~~

~~Milliseconds can also be directly enabled with the following zstyle:~~

    # [DEPRECATED] zstyle ':zim:duration-info' show-milliseconds yes

Theming
-------

To configure the format of the duration information, use the following syntax in
your prompt code:

    zstyle ':zim:duration-info' format '<string containing %d>'

The occurrence of the `%d` code in the format string is substituted by the
duration, and the `duration_info` variable is set to the formatted string. If
the duration is less than the threshold, the variable is unset instead.

In your prompt code, add `${duration_info}` to where you want the duration
information to be displayed. Usually, you'll add it to the value of either `PS1`
or `RPS1`. Also, add the `duration-info-preexec` and `duration-info-precmd`
functions to the preexec and precmd hooks respectively.

Here's an example:
```zsh
setopt nopromptbang prompt{cr,percent,sp,subst}

zstyle ':zim:duration-info' threshold 0.5
zstyle ':zim:duration-info' format '(%d) '

autoload -Uz add-zsh-hook
add-zsh-hook preexec duration-info-preexec
add-zsh-hook precmd duration-info-precmd

PS1='${duration_info}%# '
```
