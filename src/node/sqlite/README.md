# mizchi/js/node/sqlite

## node:sqlite

SQLite database bindings for Node.js (requires Node.js 22.5.0+)

### DatabaseSync
- [x] DatabaseSync::new(path, options?) - Create/open database
  - Options: readOnly, timeout, returnArrays, enableForeignKeyConstraints, defensive, allowBareNamedParameters, allowUnknownNamedParameters, allowExtension
- [x] isOpen() - Check if database is open
- [x] isTransaction() - Check if in transaction
- [x] open() - Open closed database
- [x] close() - Close database
- [x] exec(query) - Execute SQL without returning results
- [x] prepare(query) - Create prepared statement
- [x] function(name, func, options?) - Register custom SQL function
  - Options: deterministicOption, directOnlyOption, variadicOption, useBigIntForIntOption
- [x] aggregate(name, options) - Register aggregate function
  - Options: start, step, inverse, result, varargs, deterministic, directOnly, useBigIntForInt
- [x] setAuthorizer(callback) - Set authorization callback
- [x] location(dbName?) - Get database file location
- [x] loadExtension(path) - Load SQLite extension
- [x] enableLoadExtension(allow) - Enable/disable extension loading

### Session Support
- [x] createSession(options?) - Create session for changesets
- [x] applyChangeset(changeset, options?) - Apply changeset
- [x] createTagStore(name) - Create tag store

### StatementSync
- [x] get_(params?) - Get single row
- [x] all(params?) - Get all rows
- [x] run(params?) - Execute statement
- [x] iterate(params?) - Get iterator over rows
- [x] columns() - Get column metadata
- [x] setReturnArrays(enable) - Set return format
- [x] setReadBigInts(enable) - Enable BigInt for integers
- [x] setAllowBareNamedParameters(allow) - Configure named parameters
- [x] setAllowUnknownNamedParameters(allow) - Configure parameter handling

### Session Type
- [x] changeset() - Get session changeset
- [x] patchset() - Get session patchset
- [x] close() - Close session

## Test Coverage
- 43 tests in src/node/sqlite/sqlite_test.mbt covering:
  - Database creation and options
  - CRUD operations
  - Prepared statements
  - Custom functions and aggregates
  - Session and changeset operations

## Requirements
- Node.js 22.5.0 or higher
