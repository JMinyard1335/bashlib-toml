# Bash Toml

Is a tool script written in bash to be able to fetch and write values to a `.toml` file. 
As a stand alone tool it can be used to quickly grab info from a toml file in the CLI.
It can also be used in other scripts and tools in order to do things like store data to 
the file, use toml as a config file, fetch metadata about tools and programs from a toml file.

Yes long story short if u need to read or write toml in bash here ya go!


## Features

Bellow is the set of features that should be provided, tho not all are currently implemented. 
If you are intrested in helping implement any of these feel free to contribute.

- [ ] Read values from a toml file.
- [ ] Write values to a toml file.
- [ ] Check if a table exists in the toml file.
- [ ] Check if a value is in the toml file.
- [ ] Check toml file for malformed data.

## Installation

```


```


## API

Below are the api signitures that you have access to call. each of these will return a value to indicate 
what happened durring execution.

```
toml read <file> <table> <key>
toml write <file> <table> <value>
toml check [--table <table>] <file> 
toml check [--key <key>] <file>
toml check [-k <key> -t <table>] <file>
toml check <file>
```

Those return values are as follows:

```
success			= 0
error			= 1
no-table		= 2
no-key			= 3
write-failed	= 4
no-file			= 5
```

### Toml Read

Used to read the desired key from the given table. If no table/key is found then this command will output nothing.
the best way to make use of this command is to capture the stdout after it runs. 

```bash
local val=$(toml read <file> <table> <value>)
if [[ ! $? == 0 ]]; then
	echo "An error occured while reading $?"
	exit $?
fi
echo $val
```

### Toml write

### Toml Check


## Use in other projects.
