#!/usr/bin/env bash
# Copyright (c) 2026 ADBC Drivers Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_dir="$(cd "${script_dir}/../.." && pwd)/adbc_clickhouse"

if grep -q 'AdbcDriverClickhouseInit' "${source_dir}/src/lib.rs"; then
    exit 0
fi

git -C "${source_dir}" apply --unidiff-zero - <<'PATCH'
diff --git a/src/lib.rs b/src/lib.rs
--- a/src/lib.rs
+++ b/src/lib.rs
@@ -143,0 +144,11 @@
+#[cfg(feature = "ffi")]
+#[allow(non_snake_case)]
+#[unsafe(no_mangle)]
+pub unsafe extern "C" fn AdbcDriverClickhouseInit(
+    version: std::os::raw::c_int,
+    driver: *mut std::os::raw::c_void,
+    error: *mut adbc_ffi::FFI_AdbcError,
+) -> adbc_core::error::AdbcStatusCode {
+    unsafe { AdbcClickhouseInit(version, driver, error) }
+}
+
PATCH
