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
