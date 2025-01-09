#!/usr/bin/env python3

import sys
import os
from typing import Optional

# Assuming you have an OpenAI client wrapper similar to the provided example
# If not, you might need to implement one or adjust accordingly
from openai import OpenAI

class OpenAIClient:
    def __init__(self):
        openai_api_key = os.getenv("OPENAI_API_KEY")
        if not openai_api_key:
            raise EnvironmentError("OPENAI_API_KEY environment variable not set.")
        self.client = OpenAI(api_key=openai_api_key)

    def send_to_llm(self, content: str) -> str:
        """
        Sends the provided content to the LLM using the OpenAI API and returns the response.
        """
        try:
            completion = self.client.chat.completions.create(model="gpt-4o-mini",  # Use the appropriate model
            messages=[
                {"role": "user", "content": content}
            ],
            temperature=0.5,
            max_tokens=400,  # Increase max_tokens to allow for a longer response
            n=1,
            stop=None)
            response_text = completion.choices[0].message.content.strip()
            return response_text
        except Exception as e:
            print(f"Failed to generate response: {e}")
            return ""

def main():
    content = sys.stdin.read()
    client = OpenAIClient()
    commit_message = client.send_to_llm("Generate a short `git commit` message for the following `git status` and `git diff`, including file changes, deletions, moves, etc.:\n"+content)
    print(commit_message)

if __name__ == "__main__":
    main()