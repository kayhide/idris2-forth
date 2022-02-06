dev:
	find . -name "*.idr" | entr -cdr bash -c "idris2 Main.idr -o Main && build/exec/Main"
.PHONY: dev
