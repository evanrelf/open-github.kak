define-command -docstring "open-github: Open primary selection on GitHub" \
open-github %{ evaluate-commands %sh{
  root=$(git rev-parse --show-toplevel)
  repo=$(git remote get-url origin | sed -E 's#^(https://|git@)github\.com[:/]([^/]+\/[^.]+)(\.git)?$#\2#')
  rev=$(git rev-parse HEAD)
  path=$(echo "$kak_buffile" | sed "s#^$root/##")
  anchor_line=$(echo "$kak_selection_desc" | sed -E 's/^([0-9]+)\.[0-9]+,[0-9]+\.[0-9]+$/\1/')
  cursor_line=$(echo "$kak_selection_desc" | sed -E 's/^[0-9]+\.[0-9]+,([0-9]+)\.[0-9]+$/\1/')
  if [ "$anchor_line" = "$cursor_line" ]; then
    line_range="L$anchor_line"
  else
    # TODO: handle case where selection is flipped and cursor is before anchor
    line_range="L$anchor_line-L$cursor_line"
  fi
  url="https://github.com/$repo/blob/$rev/$path#$line_range"
  if [ $(uname) = "Darwin" ]; then
    open "$url"
  else
    xdg-open "$url"
  fi
}}

define-command -docstring "copy-github: Copy link to primary selection on GitHub" \
copy-github %{ evaluate-commands %sh{
  root=$(git rev-parse --show-toplevel)
  repo=$(git remote get-url origin | sed -E 's#^(https://|git@)github\.com[:/]([^/]+\/[^.]+)(\.git)?$#\2#')
  rev=$(git rev-parse HEAD)
  path=$(echo "$kak_buffile" | sed "s#^$root/##")
  anchor_line=$(echo "$kak_selection_desc" | sed -E 's/^([0-9]+)\.[0-9]+,[0-9]+\.[0-9]+$/\1/')
  cursor_line=$(echo "$kak_selection_desc" | sed -E 's/^[0-9]+\.[0-9]+,([0-9]+)\.[0-9]+$/\1/')
  if [ "$anchor_line" = "$cursor_line" ]; then
    line_range="L$anchor_line"
  else
    # TODO: handle case where selection is flipped and cursor is before anchor
    line_range="L$anchor_line-L$cursor_line"
  fi
  url="https://github.com/$repo/blob/$rev/$path#$line_range"
  if [ $(uname) = "Darwin" ]; then
    pbcopy <<< "$url"
  else
    xclip -sel clip <<< "$url"
  fi
}}
