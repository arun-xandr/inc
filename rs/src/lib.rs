#![feature(slice_patterns)]
//! # Inc
//!
//! Incremental approach to compiler construction.
//!
//!
pub mod cli;
pub mod compiler;
pub mod core;
pub mod immediate;
pub mod lambda;
pub mod parser;
pub mod primitives;
pub mod runtime;
pub mod strings;
pub mod x86;
