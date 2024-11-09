.PHONY: build
build:
	@echo "--- [GitTogether][Docker][Dev] - Building images for compose stack... ---"
	@docker compose build
	@echo "--- [GitTogether][Docker][Dev] - Built images for compose stack.      ---"

.PHONY: pull
pull:
	@echo "--- [GitTogether][Docker][Dev] - Pulling images for compose stack... ---"
	@docker compose pull
	@echo "--- [GitTogether][Docker][Dev] - Pulled images for compose stack.    ---"

.PHONY: debug
debug:
	@echo "--- [GitTogether][Docker][Dev] - Running compose stack... ---"
	@docker compose up

.PHONY: dev
dev:
	@echo "--- [GitTogether][Docker][Dev] - Running compose stack (detached)... ---"
	@docker compose up -d

.PHONY: down
down:
	@echo "--- [GitTogether][Docker][Dev] - Destroying compose stack... ---"
	@docker compose down