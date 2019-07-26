//! A string is a blob of UTF-8 encoded bytes prefixed with the length if it.
//!
//! Strings can be stack or heap allocated but static strings found in the
//! source code is retained as it is in the data section.
//!
//! Example memory layout:
//!
//! A literal "hello world" gets statically allocated at offset 4000 along with
//! the length. There is no extra allocation required for the string object
//! after immediate tagging the address as 4005 `(4000 | strtag)`.
//!
//! ```txt
//!  -------------------------
//! | Address | Value         |
//!  -------------------------
//! | 4000    | 11            |
//! | 4000    | "hello world" |
//! |         |               |
//! | 8000    | 4005          |
//!  -------------------------
//! ```
//!
//! The C runtime would get the value 4005 and would identify it as a string
//! with the tag `(8005 & mask == strtag)`. The raw pointer is obtained by
//! removing the tag `(p = val - strtag)` and length is found at the base
//! addresses `(*p)` and the data at `(*p + 1)`. fwrite can safely print the
//! exact number of bytes using the length and pointer.
//!
//! TODO: Consider switching to SDS. https://github.com/antirez/sds

use crate::{
    compiler::state::State,
    core::AST::{self, *},
    immediate,
    x86::{
        Ins::*,
        Operand::*,
        Register::{self, *},
        ASM,
    },
};
use std::convert::TryFrom;

/// Evaluate a string object
pub fn eval(s: &State, data: &str) -> ASM {
    address(s, &AST::Str(data.into()), RAX)
}

/// Inline static strings in source directly into the binary
pub fn inline(s: &State) -> ASM {
    let mut asm = ASM(vec![]);

    for (symbol, index) in s.symbols.iter() {
        // `.p2align 3` aligns the address of the following target to 8
        // bytes by setting the 3 low order bits to 0. This is necessary for
        // the immediate tagging scheme to work correctly.
        //
        // https://sourceware.org/binutils/docs-2.32/as/P2align.html
        asm += Slice("    .p2align 3 \n".to_string());
        asm += Label(label(*index));
        asm += Slice(format!("    .quad  {} \n", symbol.len()));
        asm += Slice(format!("    .ascii \"{}\" \n", symbol))
    }

    asm
}

/// Get the address of a string object
///
/// If the argument is a string literal, the address is a label in the
/// binary, if its a variable return the heap pointer instead.
fn address(s: &State, t: &AST, to: Register) -> ASM {
    match t {
        AST::Str(tag) => {
            let index = s.symbols.get(tag).unwrap_or_else(|| {
                panic!("String `{}` not found in symbol table", tag)
            });

            Lea { r: to, of: label(*index), offset: immediate::STR }.into()
        }

        AST::Identifier(i) => match s.get(&i) {
            Some(i) => Load { r: to, si: i }.into(),
            None => panic!("Undefined variable {}", i),
        },

        _ => panic!("expected string; got {:?}", t),
    }
}

/// Label for inlining symbol
fn label(index: usize) -> String {
    format!("inc_str_{}", index)
}

/// Allocate a string object in heap with a specific size
pub fn make(_: &State, size: i64) -> ASM {
    let len = i64::try_from(size).unwrap();
    let size = ((len + 7) / 8) * 8;

    Mov { to: Heap(0), from: Const(len) }
        + Mov { to: Reg(RAX), from: Reg(RSI) }
        + Or { r: RAX, v: Const(immediate::STR) }
        + Add { r: RSI, v: Const(size) }
}

/// Scan through the source and lift static strings into a symbol table for
/// inlining later.
pub fn lift(s: &mut State, prog: &AST) {
    match prog {
        Str(reference) => {
            if !s.symbols.contains_key(reference) {
                s.symbols.insert(reference.clone(), s.symbols.len());
            }
        }

        Let { bindings, body } => {
            for (_name, expr) in bindings.iter() {
                lift(s, expr);
            }

            for b in body.iter() {
                lift(s, b)
            }
        }

        List(list) => {
            for l in list.iter() {
                lift(s, l);
            }
        }
        _ => {}
    }
}