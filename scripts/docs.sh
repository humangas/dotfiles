#!/bin/bash -u

DOCS_PATH="_docs"
ROLES_PATH="roles"
SETUP_TAGS_PREFIX="${SETUP_TAGS_PREFIX:-tag.}"

init() {
    rm -rf "$DOCS_PATH"
    mkdir -p "$DOCS_PATH"
}

index_roles() {
	_header() {
cat << EOS
# humangas's dotfiles
humangas's macOS setup tool and dotfiles  
See also: [github.com/humangas/dotfiles](https://github.com/humangas/dotfiles)


EOS
	}

	_table() {
		echo -e "## roles\n" >> "$DOCS_PATH/index.md"
		echo "|role |description |" >> "$DOCS_PATH/index.md"
		echo "|:--- |:---------- |" >> "$DOCS_PATH/index.md"

		local role short_description
		for f in $(find $ROLES_PATH -type f -name "README.md"); do
			[[ $f =~ _template ]] && continue
			role=$(echo $f | cut -d/ -f2)
			[[ $role == README.md ]] && continue
			short_description=$(head -n2 $f | tail -n1)
			echo "|[$role]($role.md) |$short_description |" >> "$DOCS_PATH/index.md"
		done
	}

	_header > "$DOCS_PATH/index.md"
	_table
}

index_tags() {
    # for t in $(find $ROLES_PATH -type f -name "$SETUP_TAGS_PREFIX*"); do
    #     echo $t
    # done
	return
}

indexmd() {
	index_roles
	index_tags
}

readmemd() {
    local role
    for f in $(find $ROLES_PATH -type f -name "README.md"); do
        [[ $f =~ _template ]] && continue
        role=$(echo $f | cut -d/ -f2)
        [[ $role == README.md ]] && continue
        cp "$f" "$DOCS_PATH/$role.md"
    done
}

main() {
    init
    readmemd
    indexmd
	mkdocs build
}

main "$@"
