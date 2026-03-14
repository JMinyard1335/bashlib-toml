# Bash Toml

Is a tool script written in bash to be able to fetch and write values to a `.toml` file. 
As a stand alone tool it can be used to quickly grab info from a toml file in the CLI.
It can also be used in other scripts and tools in order to do things like store data to 
the file, use toml as a config file, fetch metadata about tools and programs from a toml file.

Yes long story short if u need to read or write toml in bash here ya go!


## Features

Bellow is the set of features that should be provided, tho not all are currently implemented. 
If you are intrested in helping implement any of these feel free to contribute.

- [ ] CLI tool
- [ ] library file to source
- [ ] Read values from a toml file.
- [ ] Write values to a toml file.
- [x] Check if a toml file exists
- [x] Check if a table exists in the toml file.
- [x] Check if a key is in the toml file under the desired table.

## Installation

```


```

## Return Codes:

Yikes we hate when something goes wrong. Which is why I try to give different return codes 
based on the problem. Bellow are all the return codes that can occur when using this library
or tool. to check the return value of the functions do the following

``` bash
toml_check_file <file>
local status="$?"
if [ "$status" -ne "" ]; then
	local err_str="$(toml_err_to_str $status)"
	toml_error "$string : $status"
fi
```

To me this is a very clean way to write this code. `toml_err_to_str` will echo the string 
representation of the error to stdout so you need to capture it with `$()`. You could also 
use bashisms to shorten it but for this guide its better to be verbose. 

Bellow are the codes that can be returned from various functions in the library.

```
success			= 0
error			= 1
no-table		= 2
no-key			= 3
write-failed		= 4
no-file			= 5
invalid-args		= 6
read-failed		= 7
```


## Using as a CLI

managing toml files from 


## Using as a Library

Want to use this tool in your own scripts as a library? the fastest way is to copy `<project-root>/libexec/bashlib_toml.sh` into your project source it where you need and have fun. 
The other way is if you want to use the full tool both CLI and Library then the best way is to use my [bashlib-installer]() project to install this project to the system. 

**Fun Fact**: the bashlib-installer uses the bashlib_toml.sh in its code to be able to parse the tool.toml files. 
