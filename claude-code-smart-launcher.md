# Claude Code Smart Launcher 🎯 (v4.6)

Este é o guia definitivo para configurar o **Claude Code Smart Launcher**, uma ferramenta que transforma sua experiência com o Claude Code CLI, permitindo alternar e selecionar dinamicamente entre **Ollama**, **OpenRouter** e **Anthropic**.

---

## 🛠️ Instalação "Do Zero ao Fim"

### 1. Pré-requisitos
- **Node.js**: [nodejs.org](https://nodejs.org/)
- **Claude Code CLI**: `npm install -g @anthropic-ai/claude-code`
- **Ollama**: [ollama.com](https://ollama.com/) (para modelos locais)

### 2. Criar Pasta de Scripts
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\scripts"
```

### 3. O Script Mestre ([claude-launch.ps1](file:///C:/Users/Wesley%20Souza/scripts/claude-launch.ps1))
Salve o código abaixo em `C:\Users\SEU_USUARIO\scripts\claude-launch.ps1`:

```powershell
function Show-Menu {
    Clear-Host
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "      CLAUDE CODE SMART LAUNCHER        " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [1] Ollama (Selector Nativo)"          -ForegroundColor Green
    Write-Host "  [2] OpenRouter (Busca Dinâmica)"       -ForegroundColor Yellow
    Write-Host "  [3] Anthropic (Oficial)"                -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  [Q] Sair" -ForegroundColor Red
    Write-Host ""
}

function Get-OpenRouterModels {
    Write-Host "Buscando modelos gratuitos no OpenRouter..." -ForegroundColor DarkGray
    try {
        $headers = @{ "Authorization" = "Bearer $($env:OPENROUTER_API_KEY)" }
        $resp = Invoke-RestMethod -Uri "https://openrouter.ai/api/v1/models" -Headers $headers -Method Get
        return $resp.data | Where-Object { $_.id -like "*:free" } | Select-Object -First 10
    } catch { return $null }
}

Show-Menu
$choice = Read-Host "Escolha o provedor"

switch ($choice.ToUpper()) {
    "1" { Write-Host "Iniciando..." -ForegroundColor Green; ollama launch claude }
    "2" {
        if (-not $env:OPENROUTER_API_KEY) { $env:OPENROUTER_API_KEY = Read-Host "Cole sua API Key" }
        $models = Get-OpenRouterModels
        if ($null -eq $models) { claude }
        else {
            Write-Host "`nSelecione um modelo gratuito:" -ForegroundColor Gray
            for ($i=0; $i -lt $models.Count; $i++) { Write-Host "  [$i] $($models[$i].id)" }
            Write-Host "  [P] Usar Anthropic/Claude-4.6-Sonnet (Pago)"
            Write-Host "  [O] Usar Anthropic/Claude-4.6-Opus (Mais Forte)"
            $mChoice = Read-Host "Opção"
            if ($mChoice.ToUpper() -eq "P") { $model = "anthropic/claude-sonnet-4.6" }
            elseif ($mChoice.ToUpper() -eq "O") { $model = "anthropic/claude-opus-4.6" }
            elseif ($mChoice -match '^\d+$' -and [int]$mChoice -lt $models.Count) { $model = $models[[int]$mChoice].id }
            else { $model = "google/gemini-2.0-flash-lite-preview-02-05:free" }
            $env:ANTHROPIC_BASE_URL = "https://openrouter.ai/api"; $env:ANTHROPIC_AUTH_TOKEN = $env:OPENROUTER_API_KEY
            claude --model $model
        }
    }
    "3" { 
        Remove-Item Env:ANTHROPIC_BASE_URL -ErrorAction SilentlyContinue 
        Remove-Item Env:ANTHROPIC_AUTH_TOKEN -ErrorAction SilentlyContinue
        claude 
    }
    "Q" { exit }
}
```

### 4. Atalho Global
No seu `$PROFILE` (digite `notepad $PROFILE`), adicione:
```powershell
Set-Alias cc "$env:USERPROFILE\scripts\claude-launch.ps1"
```

---

## 🤖 Prompt para Automação (Mestre)
"Configure o **Claude Code Smart Launcher** no meu sistema criando um diretório 'scripts', o script v4.6 com busca dinâmica de modelos (Ollama Native/OpenRouter Free Selector) e definindo o alias 'cc' no perfil do terminal (tratando caminhos com espaços)."

---
*Fonte da Verdade - Claude Code Smart Launcher*
