from fastapi import HTTPException
from openai import OpenAI
import os

# ✅ Initialize the client
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

async def get_ai_response(prompt: str, language: str = "Python"):
    """
    Generate an AI-powered code response for the given prompt and language.
    """

    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",  # ✅ use "gpt-4o" or "gpt-4o-mini"
            messages=[
                {"role": "system", "content": "You are a helpful AI coding assistant."},
                {"role": "user", "content": f"Write {language} code for the following prompt: {prompt}"}
            ]
        )

        ai_text = response.choices[0].message.content.strip()
        return {"response": ai_text}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error generating AI response: {e}")
