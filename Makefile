SHELL := /bin/bash

.PHONY: help dev run test fmt clean

help:
	@echo "Targets:"
	@echo "  make dev    - roda o servidor com auto-restart (entr) ao editar .swift"
	@echo "  make run    - roda o servidor uma vez (sem watcher)"
	@echo "  make test   - executa a suíte de testes"
	@echo "  make fmt    - formata o código (se swift-format estiver instalado)"
	@echo "  make clean  - limpa artifacts de build do SwiftPM"

dev:
	@./scripts/dev.sh

run:
	@./scripts/run.sh

test:
	@./scripts/test.sh

fmt:
	@./scripts/fmt.sh

clean:
	@./scripts/clean.sh
