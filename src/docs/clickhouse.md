---
# Copyright (c) 2026 ADBC Drivers Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
{}
---

{{ cross_reference|safe }}
# ClickHouse Driver {{ version }}

{{ heading|safe }}

This driver provides access to [ClickHouse][clickhouse], an open source data warehouse and analytical database.  It is developed by ClickHouse, Inc.  The source code can be found at [adbc_clickhouse](https://github.com/ClickHouse/adbc_clickhouse); the ADBC Driver Foundry distributes precompiled binaries of the upstream sources for Linux, macOS, and Windows.

ClickHouse is a trademark of ClickHouse, Inc. https://clickhouse.com

## Installation

The ClickHouse driver can be installed with [dbc](https://docs.columnar.tech/dbc):

```bash
dbc install --pre clickhouse
```

:::{note}
Only prerelease versions of the driver are currently available, so you must use `--pre` with dbc 0.2.0 or newer to install the driver.
:::

## Connecting

To use the driver, provide the URI of a ClickHouse database as the `uri` option.

```python
from adbc_driver_manager import dbapi

conn = dbapi.connect(
  driver="clickhouse",
  db_kwargs={
      "uri": "http://localhost:8123/",
  }
)
```

Note: The example above is for Python using the [adbc-driver-manager](https://pypi.org/project/adbc-driver-manager) package but the process will be similar for other driver managers.

## Feature & Type Support

{{ features|safe }}

### Types

{{ types|safe }}

{{ footnotes|safe }}

[clickhouse]: https://clickhouse.com/
