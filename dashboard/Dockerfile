FROM python:3.13.7-slim

COPY --from=ghcr.io/astral-sh/uv:0.12.5 /uv /uvx /bin/

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN uv sync --locked --no-dev --no-install-project

ENV PATH="/app/.venv/bin:$PATH"

COPY dashboard/ ./dashboard

EXPOSE 8501

CMD ["streamlit", "run", "dashboard/app.py", "--server.address=0.0.0.0", "--server.port=8501"]
