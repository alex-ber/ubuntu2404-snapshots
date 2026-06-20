---
name: create_python_uv_project
description: Scaffolds a new Python project using the standard boilerplate (uv, hatchling, Docker, docker-compose).
---

# Instructions

When the user asks you to create a new project based on the standard boilerplate, follow these steps to scaffold it:

1.  **Initialize Project Structure**:
    Create a new directory for the project and a `src/<project_name>` structure inside it.

2.  **pyproject.toml**:
    Create `pyproject.toml` using `hatchling` and target python 3.14.6, as shown below:

    ```toml
    [project]
    name = "<project_name>"
    dynamic = ["version"]
    description = "A new Python project."
    requires-python = ">=3.14.6"
    dependencies = []

    [build-system]
    requires = ["hatchling"]
    build-backend = "hatchling.build"

    [tool.hatch.build.targets.wheel]
    packages = ["src/<project_name>"]

    [tool.hatch.version]
    path = "src/<project_name>/__init__.py"
    ```

3.  **Source Files**:
    Create `src/<project_name>/__init__.py` (containing `__version__ = "0.0.1"`) and a main module (e.g., `main.py`).

4.  **Dockerfile**:
    Create a `Dockerfile` that uses `alexberkovich/ubuntu2404-snapshot:2025-06-16` and injects the `uv` compiler for deterministic dependency resolution:

    ```dockerfile
    FROM alexberkovich/ubuntu2404-snapshot:2025-06-16

    ENV DEBIAN_FRONTEND=noninteractive \
        PYTHONUNBUFFERED=1 \
        LANG=C.UTF-8 \
        PYTHONDONTWRITEBYTECODE=1 \
        UV_CACHE_DIR=/tmp/.uv-cache \
        UV_COMPILE_BYTECODE=1 \
        UV_LINK_MODE=copy \
        UV_PYTHON_INSTALL_DIR=/opt/python

    WORKDIR /app

    COPY --from=ghcr.io/astral-sh/uv@sha256:ff07b86af50d4d9391d9daf4ff89ce427bc544f9aae87057e69a1cc0aa369946 /uv /uvx /bin/

    RUN set -ex && \
        apt-get update && \
        apt-get install -y --no-install-recommends nano && \
        rm -rf /var/lib/apt/lists/* && \
        uv python install 3.14.6

    COPY pyproject.toml uv.lock ./

    RUN set -ex && \
        mkdir -p src/<project_name> && \
        echo '__version__ = "0.0.1"' > src/<project_name>/__init__.py && \
        uv sync --no-install-project

    COPY src/ src/

    RUN set -ex && \
        uv sync && \
        chmod -R 777 /app/.venv && \
        chmod -R 755 /opt/python && \
        chmod -R 777 /tmp/.uv-cache

    CMD ["uv", "run", "python", "-m", "src.<project_name>.main"]
    ```

5.  **Environment and Config Files**:
    Add the following auxiliary files based on the boilerplate standards:
    - `.env` and `env.example`
    - `docker-compose.yml`
    - `mise.toml`
    - `CHANGELOG.md`
    - `README.md`
    - `LICENSE`
    - `.gitignore`
    - `.gitattributes`
    - `.dockerinfo`


