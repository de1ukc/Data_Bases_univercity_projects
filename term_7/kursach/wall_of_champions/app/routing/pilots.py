from fastapi import APIRouter, Request
from app.services.pilots_service import PilotsService
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse

router = APIRouter(prefix='/pilots')

pilots_service = PilotsService()

templates = Jinja2Templates(directory="app/templates")


@router.get('/', response_class=HTMLResponse)
def home(request: Request):
    pilots: list = pilots_service.get_all_pilots()

    return templates.TemplateResponse("pilots.html", {"request": request, "pilots": pilots})
