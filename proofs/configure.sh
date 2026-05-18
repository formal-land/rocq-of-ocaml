#!/usr/bin/env sh

if command -v rocq >/dev/null 2>&1; then
  rocq makefile -f _CoqProject -o Makefile
else
  coq_makefile -f _CoqProject -o Makefile
fi
