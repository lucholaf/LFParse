LFParse
=======

iOS library to interact with the parse.com REST services, could be useful in case you want to change the backend in the future. I'm trying to keep it API consistent with current Parse SDK, so ideally a refactoring of PF* to LF* should make the migration.

Build
-----

* clone and import AFNetworking.

* add a keys.h file to the project with this template and fill it with real keys:

```
#define APP_ID @"..."
#define REST_KEY @"..."
```