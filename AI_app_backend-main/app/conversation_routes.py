from fastapi import APIRouter

router = APIRouter()

@router.get("/history")
async def get_conversation_history():
    return {"history": "Conversation history feature coming soon!"}
