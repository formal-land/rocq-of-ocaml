---
id: install
title: Install
---

We recommend to install the latest stable version of `rocq-of-ocaml` via [opam](https://opam.ocaml.org/).

## Latest stable version
Using the package manager `opam`, run:
```sh
opam install rocq-of-ocaml
```
To check that it installed correctly, type:
```sh
rocq-of-ocaml
```
It should show you the help message.

## Current development version
Install the development version to get the latest features. Clone the [GitHub repository](https://github.com/clarus/rocq-of-ocaml) with the sources and run in the root folder of the project:
```sh
opam pin add rocq-of-ocaml .
```

## Manually
Read the `rocq-of-ocaml.opam` file at the root of the project to know the updated list of dependencies of the project and commands to build it.
