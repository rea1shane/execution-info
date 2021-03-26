zmodload -F zsh/datetime +p:EPOCHREALTIME

_duration_info_preexec() {
  _duration_info_preexec_realtime=${EPOCHREALTIME}
}

_duration_info_precmd() {
  local duration_format
  zstyle -s ':zim:duration-info' format 'duration_format' || return 1
  if (( _duration_info_preexec_realtime )); then
    local -F threshold_realtime
    zstyle -s ':zim:duration-info' threshold 'threshold_realtime' || threshold_realtime=2
    local -rF duration_realtime=$(( EPOCHREALTIME - _duration_info_preexec_realtime ))
    unset _duration_info_preexec_realtime
    if (( duration_realtime >= threshold_realtime )); then
      local -ri duration_seconds=${duration_realtime}
      local -ri s=$(( duration_seconds%60 ))
      local -ri m=$(( (duration_seconds/60)%60 ))
      local -ri h=$(( duration_seconds/3600 ))
      local duration
      if (( h > 0 )); then
        duration=${h}h${m}m
      elif (( m > 0 )); then
        duration=${m}m${s}s
      elif (( threshold_realtime < 1 )) || zstyle -t ':zim:duration-info' show-milliseconds; then
        if (( duration_realtime >= 1 )); then
          printf -v duration '%.3fs' ${duration_realtime}
        else
          printf -v duration '%.0fms' $(( duration_realtime*1000 ))
        fi
      else
        duration=${duration_seconds}s
      fi
      zformat -f duration_info ${duration_format} "d:${duration}"
    else
      # Don't show duration
      unset duration_info
    fi
  else
    # Clear previous when hitting ENTER with no command to execute
    unset duration_info
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _duration_info_preexec
add-zsh-hook precmd _duration_info_precmd
