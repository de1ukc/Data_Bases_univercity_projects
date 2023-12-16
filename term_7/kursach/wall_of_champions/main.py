import uvicorn


def main():
    uvicorn.run(app='app.app:app', host="0.0.0.0", port=80, reload=True, factory=True)


if __name__ == "__main__":
    main()
