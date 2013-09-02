LFParse
=======

iOS library (Full ARC) to interact with the parse.com REST services, could be useful in case you want to change the backend in the future. I'm trying to keep the API consistent with current Parse SDK, so ideally a refactoring of PF* to LF* should make the migration.

Build
-----

* git submodule init
* git submodule update
* add a keys.h file to the project with this template and fill it with real parse.com keys. Pay attention that the key is the REST key and not the client key:

```
#define APP_ID @"..."
#define REST_KEY @"..."
```

Tests
-----

Use target LFParseTests to run the unit tests.