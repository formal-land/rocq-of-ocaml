default:
	dune build -p rocq-of-ocaml

watch:
	while inotifywait src/*.ml; do clear; make; done

clean:
	dune clean
	rm -Rf a.out tests/extraction tests/.*.aux tests/Nex* tests/*.glob tests/*.vo* tests/errors/*.ml.errors tests/errors/*.mli.errors *.coverage _coverage _coverage-summary.txt

test:
	ruby test.rb

coverage:
	rm -Rf *.coverage _coverage _coverage-summary.txt
	BISECT_FILE=rocq-of-ocaml ruby test.rb --with-coverage
	bisect-ppx-report summary --per-file > _coverage-summary.txt
	cat _coverage-summary.txt
	bisect-ppx-report html
	@echo "Outputting the coverage report in '_coverage/index.html'"
