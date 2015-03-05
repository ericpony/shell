[[ $# -lt 1 ]] && echo "usage: ./$(basename $0) ACTION (ARGS...)

 Actions  Arguments
 -------  -----------------------------------------------
  init    (root_git)
  create  project-name project-dir subtree-git (root-git)
  update  project-name
  push    project-name 
" && exit 1

[[ -d /dev/null ]] && null=/dev/null || null=NUL

function subtree {
  local action=$1
  shift
  case $action in
    init)
      if [[ ! -d .git ]]; then 
        git init
        echo > README.md
        git add README.md
        git commit -m 'create repository'
      fi
      [[ -n $1 ]] && git remote add origin "$1"
      ;;

    create)      
      project_name=$1
      project_dir=$2
      project_git=$3
      root_git=$4

      subtree init "$root_git"

      # add the project as a remote reference in your own project
      git remote add -f "$project_name" "$project_git"

      # check out the project into its own branch
      git checkout -b "$project_name" "$project_name/master"

      # switch back to master
      git checkout master

      # read master branch of remote project to project_dir.
      echo "git read-tree --prefix='$project_dir' -u '$project_name/master'" | bash

      # record the merge result
      git commit -m "Create sub-repository '$project_name'"

      subtree update "$project_name"

      subtree push "$project_name"
      ;;

    update)
      project_name=$1

      git checkout $project_name 2>$null

      git merge --squash -s subtree --no-commit "$project_name/master"

      # or if you want to merge the histories together:
      # git merge -s ours --no-commit $project_name/master

      git checkout master 
      ;;

    push)
      project_name=$1

      git checkout "$project_name" 2>$null

      git push origin "$project_name"

      git checkout master

      git push origin master
      ;;

    *)
      [[ -n $action ]] && echo Unknown action: $action 1>&2
      exit 1
      ;;
  esac
}

subtree $1 $2 $3 $4 $5 $6 $7
