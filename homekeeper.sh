#!/usr/bin/env bash

HK_NAME="homekeeper"
HK_VERSION="v1.0.0"
HK_FILENAME=`basename "$0"`

HK_DEFAULT_REPO_PATH="$HOME/.homekeeper"
HK_REPO_PATH=${HK_REPO_PATH:-${HK_DEFAULT_REPO_PATH}}
HK_TRACKED_PATH="$HOME"

HK_IGNOREFILE=".gitignore"
HK_REMOTENAME="origin"
HK_BACKEND="git"
HK_BACKEND_CMD="$HK_BACKEND --git-dir=$HK_REPO_PATH --work-tree=$HK_TRACKED_PATH"

if [ -z `which "$HK_BACKEND"` ] ; then
	echo "Error: $HK_BACKEND needs to be installed"
	exit 1
fi

function hk_has_repository {
	[ -d "$HK_REPO_PATH" ] && return 0 || return 1
}

function hk_fail_no_repo {
	echo "$HK_NAME $HK_VERSION"
	echo "No repository found. Try: $HK_FILENAME setup."
	exit 1
}

function hk_init_repository {
	if ( hk_has_repository ) ; then
		echo "Skipping creation of the repository $HK_REPO_PATH (already exists)"
	else
		echo "Creating local repository to $HK_REPO_PATH"
		mkdir -p "$HK_REPO_PATH" \
			&& cd "$HK_REPO_PATH" \
			&& $HK_BACKEND_CMD init
	fi
}

function hk_create_ignorefile {
	IGNOREFILE_FULLPATH="$HK_TRACKED_PATH/$HK_IGNOREFILE"
	if [ -e "$IGNOREFILE_FULLPATH" ] ; then
		echo "Skipping the creation of the ignorefile $IGNOREFILE_FULLPATH (already exists)"
	else
		read -p "Should we create a new ignorefile at $IGNOREFILE_FULLPATH (Y/n)?" choise
		case "$choise" in
		y | Y | '' )
			echo "Creating ignorefile $IGNOREFILE_FULLPATH"
			echo "# Created by $HK_NAME at `date`" >> $IGNOREFILE_FULLPATH
			echo "# Ignore everyhing by default" >> $IGNOREFILE_FULLPATH
			echo "*" >> $IGNOREFILE_FULLPATH
			echo "" >> $IGNOREFILE_FULLPATH
			echo "# List of tracked files" >> $IGNOREFILE_FULLPATH
			echo "!$HK_IGNOREFILE" >> $IGNOREFILE_FULLPATH
			;;
		*)
			echo "Skipping ignorefile creation"
			;;
		esac
	fi
}

function hk_setup_remote {
	if $HK_BACKEND_CMD remote show | grep -x --quiet "$HK_REMOTENAME" ; then
		echo "Remote $HK_REMOTENAME already exists, skipping setup"
	else
		echo "Remotes now:"
		$HK_BACKEND_CMD remote -v show
		echo "Provide an address for remote '$HK_REMOTENAME' (leave empty to skip): "
		read REMOTE_ADDR
		if [ -z "$REMOTE_ADDR" ] ; then
			echo "Skipping"
		else
			echo "adding remote '$HK_REMOTENAME' '$REMOTE_ADDR'"
			$HK_BACKEND_CMD remote add "$HK_REMOTENAME" "$REMOTE_ADDR"
			echo "Remotes now:"
			$HK_BACKEND_CMD remote -v show
			echo ""
			echo "If the remote already exists, next step would be:"
			echo "  $HK_FILENAME fetch $HK_REMOTENAME"
			echo "  $HK_FILENAME merge $HK_REMOTENAME/master"
		fi
	fi
}

case $1 in
	'init')
		echo "$HK_NAME $HK_VERSION"
		hk_init_repository
		hk_create_ignorefile
		hk_setup_remote
		;;

	'ls' | 'versioned' )
		if ( hk_has_repository ) ; then
			$HK_BACKEND_CMD ls-tree -r --name-only HEAD
		else
			hk_fail_no_repo
		fi
		;;

	'' | 'help' | '-h' | '--help' )
		echo "$HK_NAME $HK_VERSION"
		echo ""
		echo "My personal way of versioning home without affecting git -command elsewhere,"
		echo "aka. lazy-wrapper for git with renamed git-dir."
		echo ""
		echo "Config:"
		echo "    Backend: $HK_BACKEND"
		echo "   Tracking: $HK_TRACKED_PATH"
		echo " Repository: $HK_REPO_PATH"
		echo ""
		echo "Usage:"
		echo "  $HK_FILENAME                   # this help"
		echo "  $HK_FILENAME init              # setup tracking of $HK_TRACKED_PATH"
		echo "  $HK_FILENAME arg1 [arg2 [..]]  # passthrough to $HK_BACKEND using configs above"
		echo "  $HK_FILENAME ls|versioned      # list files under homekeeper"
		echo ""
		echo "Passthrough commands to:"
		echo "  $HK_BACKEND_CMD"
		;;

	'-v' | '--version')
		echo "$HK_NAME $HK_VERSION"
		;;

	*)
		if ( hk_has_repository ) ; then
			$HK_BACKEND_CMD "$@"
		else
			hk_fail_no_repo
		fi
		;;
esac
