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
# [DEPENDENCY_GRAPH_ALLOCATION]: alexsmail-dns-fix
# Strict PEP 621 compliance for target environment

    [project]
    name = "<project_name>"
    dynamic = ["version"]
    description = "A new Python project."
    requires-python = ">=3.14.6"
 
    # [EXTERNAL_DEPENDENCIES]:
    dependencies =[
     "structlog>=26.1.0, <27.0.0"
    ]

    [build-system]
    requires = ["hatchling"]
    build-backend = "hatchling.build"

    # [POINTER_ALLOCATION]: Directing the transpiler to the isolated OR
    [tool.hatch.build.targets.wheel]
    packages = ["src/<project_name>"]

    [tool.hatch.version]
    path = "src/<project_name>/__init__.py"

    #uv pip install structlog --dry-run

    ```

3.  **Source Files**:
    Create `src/<project_name>/__init__.py` (containing `__version__ = "0.0.1"`) and a main module (e.g., `main.py`).

4.  **Dockerfile**:
    Create a `Dockerfile` that uses `alexberkovich/ubuntu2404-snapshot:2025-06-16` and injects the `uv` compiler for deterministic dependency resolution:

    ```dockerfile
    FROM alexberkovich/ubuntu2404-snapshot:2025-06-16

    #[HARDWARE_CONFIG]: Deterministic execution and compilation flags
    # Consolidated environment variables to reduce layer allocation overhead.
    ENV DEBIAN_FRONTEND=noninteractive \
        PYTHONUNBUFFERED=1 \
        LANG=C.UTF-8 \
        PYTHONDONTWRITEBYTECODE=1 \
        UV_CACHE_DIR=/tmp/.uv-cache \
        UV_COMPILE_BYTECODE=1 \
        UV_LINK_MODE=copy \
        UV_PYTHON_INSTALL_DIR=/opt/python

    WORKDIR /app

    #[HARDWARE_BRIDGE]: Injecting UV Compiler (AOT Dependency Graph Resolver)
    COPY --from=ghcr.io/astral-sh/uv@sha256:ff07b86af50d4d9391d9daf4ff89ce427bc544f9aae87057e69a1cc0aa369946 /uv /uvx /bin/
    
    #[RUNTIME_ENVIRONMENT]: Deterministic APT Projection & Root Python Allocation
    RUN set -ex && \
        apt-get update && \
        apt-get install -y --no-install-recommends nano && \
        rm -rf /var/lib/apt/lists/* && \
        uv python install 3.14.6

    #[DEPENDENCY_INJECTION]: Top-Down Directed Acyclic Graph Mount
    COPY pyproject.toml uv.lock ./

    #[POINTER_ALLOCATION]: Synthetic Mock-Node Cache Strategy
    # Bypasses hatchling early parse exception, isolating dependency layer from source layer jitter.
    RUN set -ex && \
        mkdir -p src/<project_name> && \
        echo '__version__ = "0.0.1"' > src/<project_name>/__init__.py && \
        uv sync --no-install-project

    #[AST_COPY]: Mount Root Logic
    COPY src/ src/

    #[PROJECT_INJECTION]: Finalize Symbol Table Linkage
    RUN set -ex && \
        uv sync && \
        chmod -R 777 /app/.venv && \
        chmod -R 755 /opt/python && \
        chmod -R 777 /tmp/.uv-cache # && \
        #mkdir -p /app/logs && \
        #chmod -R 777 /app/logs
        

    CMD ["uv", "run", "python", "-m", "src.<project_name>.main"]
    ```

5.  **Environment and Config Files**:
    Copy the auxiliary files from the skill's `resources/` directory (`~/.gemini/config/skills/create_python_uv_project/resources/`) into the root of the new project:
    - `env.example`
    - `.env`
    - `docker-compose.yml`
    - `mise.toml`
    - `CHANGELOG.md`
    - `README.md`
    - `LICENSE`
    - `.gitignore`
    - `.gitattributes`
    - `.dockerinfo`
    - `.devcontainer`
    - `.vscode`

6.  **Setup Lockfile**:
    Run `uv lock` inside the new project directory to generate the `uv.lock` file.

7.  **Initialize Git**:
    Run the following commands in the project root:
    ```bash
    git init
    git add .
    git commit -m "Initital commit"
    git remote add origin https://github.com/alex-ber/<project_name>.git
    ```

