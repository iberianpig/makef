# makef

Override `Makefile` for developer local environment

* Extend Makefile with overriding tasks
* Behave like make -f `make -f /path/to/git/ignored/Makefile`
* Override the project's Makefile tasks in local envirioment
* Unify commands for developer's local between different projects
* No more wrong selections from Ctrl-r's command line history
* Support `bash-completion`

## Installation

### 1. Install makef

register `makef` to `~/.bashrc`

```shell
$ git clone https://github.com/iberianpig/makef
$ echo -e "# makef\nsource $(find `pwd` -name makef.sh)" >> ~/.bashrc
$ source ~/.bashrc
```

### 2. Install direnv

`makef` use `direnv` to set `$MAKEF_PATH` to envirionment variables

see: https://github.com/direnv/direnv

## Usage

`./Makefile` (default Makefile)

```Makefile
task1: ## Sample task
	echo "this is Makefile"

task2: task1 ## task overridden in next step
	echo "from ./Makefile"
```

### Overriding tasks with vcs-ignored Makefile

Overriding Makefile must be set it in `.git/` or to a path ignored by `.gitignored`

```Makefile
task2: task1 ## orverriding task
	echo "from .git/Makefile"

help: ## show help
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "} { comments[$$1] = $$2 } \
		END { for(task in comments) printf "\033[36m%-30s\033[0m %s\n", task, comments[task]}'
```


### export MAKEF_PATH in `.envrc`

Add `export MAKEF_PATH=/path/to/ignored/Makefile` to `.envrc` on your project

Edit `.envrc`

```sh
export MAKEF_PATH=.git/Makefile
```

Then run `direnv allow`

```shell
$ direnv allow
direnv: loading .envrc
direnv: export +MAKEF_PATH
```

### Use `makef` instead of `make`

```shell
$ makef help
/tmp/tmp.u0vZq8mzkG:8: warning: overriding recipe for target 'task2'
/tmp/tmp.u0vZq8mzkG:5: warning: ignoring old recipe for target 'task2'
task1                          sample task
task2                          orverriding task
help                           show help

$ makef task1
/tmp/tmp.cQARE0rtXT:8: warning: overriding recipe for target 'task2'
/tmp/tmp.cQARE0rtXT:5: warning: ignoring old recipe for target 'task2'
echo "this is Makefile"
this is Makefile

$ makef task2
/tmp/tmp.CI2hKcYZIH:8: warning: overriding recipe for target 'task2'
/tmp/tmp.CI2hKcYZIH:5: warning: ignoring old recipe for target 'task2'
echo "this is Makefile"
this is Makefile
echo "from .git/Makefile"
from .git/Makefile
```

### bash-completion with `Tab` key

```shell
$ makef # press Tab key
help   task1  task2
```
