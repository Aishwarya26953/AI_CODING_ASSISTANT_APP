from openai import OpenAI
from fastapi import APIRouter
from pydantic import BaseModel
from app.services import get_ai_response

router = APIRouter(prefix="/ai", tags=["AI Code Generator"])

class CodePrompt(BaseModel):
    prompt: str
    language: str = "Python"

@router.post("/chat")
async def ai_chat(request: CodePrompt):
    return await get_ai_response(request.prompt, request.language)

