from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def index():
    return {
        "Hello": "World",
        "package_manager": "pip",
    }


@app.get("/health-check")
async def health_check():
    return {
        "status": "healthy",
    }
