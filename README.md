# RLinuxModules
R package that makes linux [environment modules](http://modules.sourceforge.net/) available from R.

## How it works
The Modules Environment does not support R scripting but does support Python. This package works by using the python support and translating the python commands returned from *modulecmd python* into R commands. It has only been tested for version 3.2.10 
