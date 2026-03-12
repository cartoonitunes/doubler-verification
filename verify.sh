#!/bin/bash
# Verify Doubler runtime bytecode matches on-chain deployment
# Contract: 0xc1824278b767d9efb304c63128b1a92babc3fa4b
# Usage: ./verify.sh [solc-version]
#
# Requires: node, curl

set -euo pipefail

SOLC_VERSION="${1:-v0.2.1+commit.91a6b35f}"
SOLC_BIN=".solc-bins/soljson-${SOLC_VERSION}.js"
SOLC_URL="https://binaries.soliditylang.org/bin/soljson-${SOLC_VERSION}.js"

mkdir -p .solc-bins
if [ ! -f "$SOLC_BIN" ]; then
  echo "Downloading solc ${SOLC_VERSION}..."
  curl -sL "$SOLC_URL" -o "$SOLC_BIN"
fi

node -e "
var fs = require('fs');
var src = fs.readFileSync('Doubler.sol', 'utf8');
var target = fs.readFileSync('runtime-bytecode.txt', 'utf8').trim();

var Module = require('./${SOLC_BIN}');
var compile = Module.cwrap('compileJSON', 'string', ['string', 'number']);
var output = JSON.parse(compile(src, 1));

var errs = (output.errors || []).filter(function(e) { return e.indexOf('Error') >= 0; });
if (errs.length) { console.error('Compile errors:', errs); process.exit(1); }

var rt = '0x' + output.contracts['Doubler'].runtimeBytecode;
if (rt === target) {
  console.log('✅ EXACT MATCH');
  console.log('   Runtime bytecode: ' + (rt.length - 2) / 2 + ' bytes');
  console.log('   Compiler: solc ' + '${SOLC_VERSION}' + ' (optimizer enabled)');
  console.log('   Contract: 0xc1824278b767d9efb304c63128b1a92babc3fa4b');
} else {
  console.log('❌ MISMATCH');
  console.log('   Ours:   ' + rt.length + ' chars');
  console.log('   Target: ' + target.length + ' chars');
  process.exit(1);
}
"
