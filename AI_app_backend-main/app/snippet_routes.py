from openai import OpenAI
from fastapi import APIRouter

router = APIRouter()

@router.get("/saved")
async def get_saved_snippets():
    return {"snippets": "Snippet saving feature coming soon!"}

