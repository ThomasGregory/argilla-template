# 🏺 Argilla

**Argilla** is a shapeable, reproducible Python project template — designed for weekend hacks, experimental work, and portable development across systems.

It provides:
- 🐍 Pure Python development using `uv`
- 🐳 Docker-based reproducible environments
- 📒 Jupyter notebook support
- ⚙️ Optional Flask or Django integration
- 🧪 Built-in testing, linting, and type-checking

---

## 🚀 Getting Started

### 1. Clone and Build

```bash
git clone https://github.com/yourusername/argilla.git
cd argilla
make build        # Build the Docker container
make install      # Install all dependencies with uv
```

---

## 🧱 Development Workflow

### Launch a dev shell inside the container:

```bash
make run
```

This gives you:
- Python + uv
- Flask, Django, Jupyter
- `pytest`, `ruff`, `mypy` ready to go

---

## 📒 Jupyter Notebooks

### Run Locally (on your machine):

```bash
make notebook
```

Then open [http://localhost:8888](http://localhost:8888)

---

### Run Securely on a Remote Server (e.g. EC2)

**On the EC2 instance:**

```bash
make jupyter_headless
```

**On your laptop:**

```bash
ssh -i <your-key.pem> -L 8888:localhost:8888 ec2-user@<your-ec2-ip>
```

Then open [http://localhost:8888](http://localhost:8888)

To print this again later:

```bash
make ssh-tunnel
```

---

## 🧪 Testing and Linting

Run type checks, linter, and tests all in one:

```bash
make test
```

This runs:
- `ruff` (style)
- `mypy` (types)
- `pytest` (unit tests)

---

## ⚙️ Run a Web App

To serve a web app from within the container:

```bash
make runserver
```

- Runs `flask run` if `app.py` exists
- Runs `python manage.py runserver` if `manage.py` exists
- Flask will default to port 5000, Django to 8000

---

## 🧼 Cleanup

Stop and remove containers/images:

```bash
make down      # Stop background container
make clean     # Remove container and image
```

---

## 📁 Included Tools

- Python 3.11 (via Docker)
- `uv` for dependency management
- `ruff`, `mypy`, `pytest`
- `jupyter`, `pandas`, `matplotlib`
- Flask and Django pre-installed

---

## 📜 License

MIT. See `LICENSE`.
