IMAGE_NAME = argilla-dev
CONTAINER_NAME = argilla-container
INSTALL_TARGET = .[dev]
PORTS = -p 5000:5000 -p 8000:8000 -p 8888:8888
WORKDIR = /home/devuser/app

# Build the dev container image
build:
	docker build -t $(IMAGE_NAME) .

# Start container in interactive shell with no exposed ports
run: build
	docker run --rm -it \
		--name $(CONTAINER_NAME) \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) bash

# Start container in background (no exposed ports)
up: build
	docker run -d --name $(CONTAINER_NAME) \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME)

# Stop background container
down:
	docker stop $(CONTAINER_NAME)

# Install project + dev dependencies
install:
	docker run --rm -it \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) uv pip install $(INSTALL_TARGET)

# Run combined lint + typecheck
check:
	docker run --rm -it \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) sh -c "ruff check . && mypy argilla"

# Run tests (after lint/typecheck)
test: check
	docker run --rm -it \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) pytest

# Launch a Jupyter notebook with ports (LOCAL ONLY)
notebook:
	docker run --rm -it \
		$(PORTS) \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root

# Launch Jupyter notebook without exposing ports (for SSH tunnel)
jupyter_headless:
	docker run --rm -it \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root

# Launch app server (Flask/Django detection, LOCAL ONLY)
runserver:
	docker run --rm -it \
		$(PORTS) \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) sh -c "\
			if [ -f manage.py ]; then \
				python manage.py runserver 0.0.0.0:8000; \
			elif [ -f app.py ]; then \
				flask run --host=0.0.0.0 --port=5000; \
			else \
				echo 'No server entry point found'; \
			fi"

# Print SSH tunnel instructions for EC2
ssh-tunnel:
	@echo ""
	@echo "📡 To access Jupyter securely on EC2:"
	@echo ""
	@echo "  ssh -i <your-key.pem> -L 8888:localhost:8888 ec2-user@<your-ec2-ip>"
	@echo ""
	@echo "Then visit: http://localhost:8888"
	@echo ""

rust:
	docker run --rm -it \
		-v $$PWD:/home/devuser/app \
		-w /home/devuser/app/rust_ext \
		$(IMAGE_NAME) maturin develop


verify: build
	docker run --rm -it \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) sh -c "\
			uv venv && \
			uv pip install .[dev] && \
			cd rust_ext && maturin develop && cd .. && \
			ruff check . && \
			mypy argilla && \
			pytest"

devshell: build
	docker run -it \
		--name $(CONTAINER_NAME) \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) bash

attach:
	docker exec -it $(CONTAINER_NAME) bash

logs:
	docker logs -f $(CONTAINER_NAME)

restart:
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true
	docker run -it \
		--name $(CONTAINER_NAME) \
		-v $$PWD:$(WORKDIR) \
		-w $(WORKDIR) \
		$(IMAGE_NAME) bash



# Clean up image/container
clean:
	docker rm -f $(CONTAINER_NAME) || true
	docker image rm $(IMAGE_NAME) || true

.PHONY: build run up down install check test notebook jupyter_headless runserver ssh-tunnel clean
