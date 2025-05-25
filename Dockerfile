FROM python:3.11-slim

# Install uv + compilers + build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    clang \
    libssl-dev \
    libffi-dev \
    pkg-config \
    python3-dev \
    curl \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install uv globally
RUN pip install --no-cache-dir uv

# Create non-root dev user before setting up venv/Rust
RUN useradd -ms /bin/bash devuser

# Switch to devuser for all further setup
USER devuser
WORKDIR /home/devuser/app

# Install Rust as devuser
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/home/devuser/.cargo/bin:$PATH"

# Create a uv-managed virtualenv as devuser
RUN uv venv --prompt argilla .venv
ENV VIRTUAL_ENV="/home/devuser/app/.venv"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Optional: activate venv on shell entry
RUN echo 'source .venv/bin/activate' >> ~/.bashrc

CMD ["bash"]
