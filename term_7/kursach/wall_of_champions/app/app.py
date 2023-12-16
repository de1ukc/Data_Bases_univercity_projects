from fastapi import FastAPI
from app.routing.pilots import router as pilots_router


def create_app() -> FastAPI:
    app = FastAPI(debug=True)

    return app


def app() -> FastAPI:
    app = create_app()
    print('app created')
    app.include_router(pilots_router)
    return app
