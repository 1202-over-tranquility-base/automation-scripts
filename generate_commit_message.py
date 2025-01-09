#!/usr/bin/env python3

import sys
import openai
import os

def generate_commit_message(diff_text):
    # Ensure the OpenAI API key is set
    openai_api_key = os.getenv("OPENAI_API_KEY")
    if not openai_api_key:
        print("Error: OPENAI_API_KEY environment variable not set.")
        sys.exit(1)
    
    openai.api_key = openai_api_key

    prompt = (
        "Generate a concise and meaningful git commit message based on the following changes:\n\n"
        f"{diff_text}\n\n"
        "Commit Message:"
    )

    try:
        response = openai.Completion.create(
            engine="text-davinci-004",  # Use the appropriate engine
            prompt=prompt,
            max_tokens=60,
            temperature=0.5,
            n=1,
            stop=["\n"]
        )
        commit_message = response.choices[0].text.strip()
        return commit_message
    except Exception as e:
        print(f"Error generating commit message: {e}")
        sys.exit(1)

def main():
    # Read diff from stdin
    diff = sys.stdin.read()
    commit_message = generate_commit_message(diff)
    print(commit_message)

if __name__ == "__main__":
    main()
