// Copyright 2020 Matt Aamold, James Aamold
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Language: Verilog 2001

// Default setting marked with D for enabled
`define NUMBER_OF_MACROS 8 // -- value required
`define USE_REG_WRITE_TO_HASHMACRO // D-- register write ops to hash macros
`define USE_VARIABLE_NONCE_OFFSET // D--
//`define USE_SYSTEM_VERILOG //  -- 
`define USE_NONBLOCKING_HASH_MACRO // D-- comment-out for blocking
//`define FULL_CHIP_SIM //  --
