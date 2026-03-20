#!/bin/bash

# Claude Code Smart Launcher for macOS/Linux (v3.0)

show_menu() {
    clear
    echo "========================================"
    echo "      CLAUDE CODE SMART LAUNCHER        "
    echo "========================================"
    echo ""
    echo "  [1] Ollama (Native Selector)"
    echo "  [2] OpenRouter (Dynamic Search)"
    echo "  [3] Anthropic (Official)"
    echo ""
    echo "  [Q] Exit"
    echo ""
}

get_openrouter_models() {
    echo "Searching for free models on OpenRouter..." >&2
    if [ -z "$OPENROUTER_API_KEY" ]; then
        return 1
    fi
    
    # Use curl to fetch models
    resp=$(curl -s -X GET "https://openrouter.ai/api/v1/models" \
        -H "Authorization: Bearer $OPENROUTER_API_KEY")
    
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # Extract free models using grep/sed (minimal dependencies)
    echo "$resp" | grep -o '"id":"[^"]*:free"' | sed 's/"id":"//;s/"//' | head -n 10
}

show_menu
read -p "Choose provider: " choice

case $choice in
    1)
        echo "Starting Ollama..."
        ollama launch claude
        ;;
    2)
        if [ -z "$OPENROUTER_API_KEY" ]; then
            read -sp "Paste your OpenRouter API Key: " OPENROUTER_API_KEY
            echo ""
            export OPENROUTER_API_KEY
        fi
        
        models=$(get_openrouter_models)
        
        if [ -z "$models" ]; then
            echo "No free models found or error fetching. Launching default Claude..."
            claude
        else
            echo -e "\nSelect a free model:"
            IFS=$'\n' read -rd '' -a model_array <<< "$models"
            
            for i in "${!model_array[@]}"; do
                echo "  [$i] ${model_array[$i]}"
            done
            echo "  [P] Use Anthropic/Claude-3.7-Sonnet (Paid)"
            
            read -p "Option: " mChoice
            
            if [[ "$mChoice" == "P" || "$mChoice" == "p" ]]; then
                model="anthropic/claude-3-7-sonnet"
            elif [[ "$mChoice" =~ ^[0-9]+$ ]] && [ "$mChoice" -lt "${#model_array[@]}" ]; then
                model="${model_array[$mChoice]}"
            else
                model="google/gemini-2.0-flash-lite-preview-02-05:free"
            fi
            
            export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
            export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
            
            echo "Launching Claude with model: $model"
            claude --model "$model"
        fi
        ;;
    3)
        unset ANTHROPIC_BASE_URL
        unset ANTHROPIC_AUTH_TOKEN
        claude
        ;;
    [Qq])
        exit 0
        ;;
    *)
        echo "Invalid option."
        ;;
esac
