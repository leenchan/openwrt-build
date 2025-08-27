DL_TMP_DIR="/tmp/.dl"

get_urls_from_html() {
	__SOURCE__=$1
	echo "$__SOURCE__" | grep -Eq 'https?://[^"]+' && __SOURCE__=$(curl -skL "$__SOURCE__")
	echo "$__SOURCE__" | grep -Eo 'href="[^"]+"' | awk -F'"' '{print $2}'
}

get_github_release() {
	__REPO__=$1
	__TAG__=$2
	[ -z "${__TAG__}" ] && {
		__TAG__=$(curl -sI https://github.com/${__REPO__}/releases/latest | grep -Ei '^Location:' | awk -F'/' '{print $NF}' | tr -d '\r')
	}
	[ -z "${__TAG__}" ] && return 1
	__DL_URLS__=$(get_urls_from_html "https://github.com/${__REPO__}/releases/expanded_assets/${__TAG__}")
	[ -z "${__DL_URLS__}" ] && return 1
	__DL_URLS__=$(echo "${__DL_URLS__}" | sed -E 's|(.*)|https://github.com\1|g')
	if [ -z "$3" ]; then
		echo "${__DL_URLS__}"
	else
		echo "${__DL_URLS__}" | grep "$3" | head -n1
	fi
}

install_binary() {
	__DL_TMP_DIR__="$DL_TMP_DIR/$(date +%s)"
	[ -d "$__DL_TMP_DIR__" ] || mkdir -p "$__DL_TMP_DIR__"
	__FILE_NAME__=$(basename "$1" | sed -E 's/\?.*//g')
	__FILE_PATH__="$__DL_TMP_DIR__/$__FILE_NAME__"
	echo "$1" | grep -Eq 'https?://[^"]+' && {
		curl -skL -o "$__FILE_PATH__" "$1" || return 1
		if file "$__FILE_PATH__" | grep -Eqi 'zip archive'; then
			unzip -o "$__FILE_PATH__" -d "$__DL_TMP_DIR__" || return 1
		elif file "$__FILE_PATH__" | grep -Eqi 'gzip compressed'; then
			tar -xzf "$__FILE_PATH__" -C "$__DL_TMP_DIR__" || return 1
		fi
		while read __TO_INSTALL__; do
		done <<-EOF
		$(echo "$2")
		EOF
		while read -r __F__; do
			if [ -f "$__F__" ]; then
				sudo cp -f "$__F__" /usr/local/bin/ || return 1
				sudo chmod +x /usr/local/bin/$(basename "$__F__") || return 1
			fi
		done < <(find "$__DL_TMP_DIR__" -type f)
	}
	return 0
	echo "$__FILE_PATH__"
}