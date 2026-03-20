# Claude Code Smart Launcher 🎯 (v4.6)

Este projeto oferece uma solução inteligente para gerenciar e alternar entre diferentes provedores de IA ao usar o **Claude Code CLI**. Com este launcher, você pode selecionar dinamicamente entre **Ollama**, **OpenRouter** (modelos gratuitos e premium) e a API oficial da **Anthropic**.

---
Desenvolvido por **Wesley Souza** 🚀
---

## 🏎️ O Conceito: Carro vs Motor

Imagine que o **Claude Code** é um carro de Fórmula 1:
- **O Carro**: São as skills, MCPs, memória e contexto. É a estrutura potente que permite realizar tarefas complexas.
- **O Motor**: É a LLM (o modelo) que faz o carro andar. 

O problema é que o motor oficial (Opus) pode ser caro. Este launcher permite que você **troque o motor** do seu carro de F1, colocando modelos como **Gemini 2.5 Pro** ou modelos gratuitos do **OpenRouter**, mantendo todas as funcionalidades (skills) do Claude Code.

## 🚀 Recursos

- **Multi-plataforma**: Versões compatíveis com **Windows**, **macOS** e **Linux**.
- **Menu Interativo**: Seleção simples via teclado.
- **Suporte Ollama**: Use modelos locais com facilidade.
- **OpenRouter Dinâmico**: Busca automática dos 10 principais modelos gratuitos disponíveis.
- **Alternância de Contexto**: Configura automaticamente as variáveis de ambiente necessárias (`ANTHROPIC_BASE_URL` e `ANTHROPIC_AUTH_TOKEN`).
- **Alias Global**: Atalho rápido `cc` para iniciar o launcher de qualquer lugar.

## 🛠️ Pré-requisitos

Antes de começar, certifique-se de ter instalado:

1. **Node.js**: [Acesse o site oficial](https://nodejs.org/)
2. **Claude Code CLI**: 
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```
3. **Ollama**: **Obrigatório apenas para modelos locais** (Opção 1). Se você for usar apenas OpenRouter ou Anthropic (nuvem), não precisa instalá-lo. [ollama.com](https://ollama.com/)

---

## 📦 Instalação (Windows)

### 1. Criar Pasta de Scripts
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\scripts"
```

### 2. Copiar o Script
Copie o arquivo `scripts/windows/claude-launch.ps1` para a pasta `$env:USERPROFILE\scripts\`.

### 3. Configurar Alias
No terminal, digite `notepad $PROFILE` e adicione:
```powershell
Set-Alias cc "$env:USERPROFILE\scripts\claude-launch.ps1"
```

---

## 📦 Instalação (macOS / Linux)

### 1. Criar Pasta de Scripts
```bash
mkdir -p ~/scripts
```

### 2. Copiar e dar Permissão
Copie o arquivo `scripts/macos/claude-launch.sh` para `~/scripts/` e dê permissão de execução:
```bash
chmod +x ~/scripts/claude-launch.sh
```

### 3. Configurar Alias
No seu arquivo de perfil (`~/.zshrc` ou `~/.bashrc`), adicione:
```bash
alias cc='~/scripts/claude-launch.sh'
```
Depois, execute `source ~/.zshrc` (ou o arquivo correspondente).

---

## 🛡️ Segurança e Configuração

Para não precisar digitar sua API Key toda vez, você pode configurá-la permanentemente no seu sistema:

**Windows (PowerShell):**
```powershell
[System.Environment]::SetEnvironmentVariable('OPENROUTER_API_KEY', 'sua_chave_aqui', 'User')
```

**macOS/Linux (Bash/Zsh):**
Adicione ao seu `~/.zshrc` ou `~/.bashrc`:
```bash
export OPENROUTER_API_KEY='sua_chave_aqui'
```

## 🎮 Como Usar

Basta digitar `cc` no seu terminal e escolher uma das opções:

- **[1] Ollama**: Lança o Claude usando o backend do Ollama.
- **[2] OpenRouter**: Busca modelos gratuitos e permite selecionar o **Gemini 2.5 Pro (Recomendado)** ou os novos **Claude 4.6 Sonnet/Opus**.
- **[3] Anthropic**: Usa a configuração oficial padrão.
- **[Q] Sair**: Encerra o launcher.

---
*Desenvolvido por Wesley Souza para otimizar o fluxo de trabalho com Claude Code.*
