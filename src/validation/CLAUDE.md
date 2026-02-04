<!--
  Copyright (c) 2026 ADBC Drivers Contributors

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

          http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

# Validation Tests Guide

## Task

Get validation tests passing using `pixi run validate`. Use `-k` to run a single test or pattern, e.g., `pixi run validate -k type/select/string`.

## Handling Test Failures

### Query-based tests (type/select, type/literal, type/bind, ingest)

1. **Override queries**: If ClickHouse requires different SQL syntax, create override query files in `./validation/queries/` using the `.txtcase` format.  Do not override sections that are identical to the base query.  When overriding, check the documentation for the database and add `tags.sql-type-name` to the TOML metadata to reflect the "canonical" type name for that data type.  Also, if data values need to be changed, make sure "extreme" values are tested.  For example, timestamps/datetimes should test the ANSI SQL extremes of 0001-01-01 and 9999-12-31, or if not possible, they should test the extremes of the database.

2. **Mark as broken**: If a test cannot pass due to driver or vendor limitations, add to the metadata section:
   - `[tags] broken-driver = "reason"` - for driver limitations
   - `[tags] broken-vendor = "reason"` - for ClickHouse limitations

   For ClickHouse limitations, try to link to database documentation.

3. **Hide tests**: Use `hide = true` in metadata to completely hide irrelevant tests.

### Non-query tests (connection, statement)

Subclass the test class and add `@pytest.mark.xfail(reason="...")` decorator to the method.

## Override Query Format (.txtcase)

Override files go in `./validation/queries/` mirroring the structure in `adbc-drivers-validation`. Only include the parts you need to override.

```
// Copyright (c) 2026 ADBC Drivers Contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// ...

// part: metadata

[setup]
drop = "test_tablename"

[tags]
sql-type-name = "TYPE"

// part: setup_query

CREATE TABLE ...

// part: query

SELECT ...

// part: expected_schema

{ JSON schema }

// part: expected

{ JSON data rows }
```

Parts map to file extensions:
- `metadata` -> .toml
- `setup_query` -> .setup.sql
- `query` -> .sql
- `expected_schema` -> .schema.json
- `expected` -> .json
- `bind_query` -> .bind.sql
- `bind_schema` -> .bind.schema.json
- `bind` -> .bind.json

## ClickHouse-Specific SQL Requirements

1. **Nullable columns**: Use `Nullable(Type)` wrapper, e.g., `Nullable(Int32)`
2. **Table engine**: Add `ENGINE = MergeTree() ORDER BY idx`
3. **Types**: Use ClickHouse type names (Int32, Int64, Bool, etc.)

## Workflow

1. Run the specific test to see the failure: `pixi run validate -k "type/select/int32"`
2. Check expected data in `~/Code/adbc-drivers-validation/adbc_drivers_validation/queries/`
3. Create override .txtcase file with correct data matching expected output
4. Test the query after creating each file
5. Move to next failing test

## Copyright Header

All new files must include the Apache 2.0 license header with copyright year 2026:

```
// Copyright (c) 2026 ADBC Drivers Contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// ...
```
