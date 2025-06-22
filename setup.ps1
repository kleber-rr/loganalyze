# Script de Setup para Windows PowerShell
# LogAnalyze n8n - Automação de Análise de Logs

Write-Host "🚀 Configurando LogAnalyze n8n - Automação de Análise de Logs" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green

# Verificar se Docker está instalado
try {
    docker --version | Out-Null
    Write-Host "✅ Docker encontrado" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker não está instalado. Por favor, instale o Docker Desktop primeiro." -ForegroundColor Red
    exit 1
}

# Verificar se Docker Compose está instalado
try {
    docker-compose --version | Out-Null
    Write-Host "✅ Docker Compose encontrado" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro." -ForegroundColor Red
    exit 1
}

# Criar diretório de configuração
if (!(Test-Path "n8n-config")) {
    New-Item -ItemType Directory -Path "n8n-config"
    Write-Host "📁 Diretório n8n-config criado" -ForegroundColor Yellow
}

# Verificar se arquivo .env existe
if (!(Test-Path ".env")) {
    Write-Host "📝 Criando arquivo .env baseado no exemplo..." -ForegroundColor Yellow
    Copy-Item "env.example" ".env"
    Write-Host "⚠️  IMPORTANTE: Configure as variáveis no arquivo .env antes de continuar!" -ForegroundColor Red
    Write-Host "   - BUGSNAG_API_TOKEN" -ForegroundColor Yellow
    Write-Host "   - CLICKUP_API_TOKEN" -ForegroundColor Yellow
    Write-Host "   - IDs dos agentes" -ForegroundColor Yellow
    Write-Host "   - Configurações de notificação" -ForegroundColor Yellow
    Read-Host "Pressione Enter após configurar o arquivo .env"
}

# Carregar variáveis de ambiente
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^([^#][^=]+)=(.*)$") {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
        }
    }
}

Write-Host "🔧 Iniciando n8n..." -ForegroundColor Yellow
docker-compose up -d

Write-Host "⏳ Aguardando n8n inicializar..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "✅ n8n iniciado com sucesso!" -ForegroundColor Green
Write-Host "🌐 Acesse: http://localhost:5678" -ForegroundColor Cyan
Write-Host "👤 Usuário: $env:N8N_BASIC_AUTH_USER" -ForegroundColor Cyan
Write-Host "🔑 Senha: $env:N8N_BASIC_AUTH_PASSWORD" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Próximos passos:" -ForegroundColor Yellow
Write-Host "1. Acesse o n8n e configure as credenciais" -ForegroundColor White
Write-Host "2. Importe o fluxo de trabalho do arquivo workflow.json" -ForegroundColor White
Write-Host "3. Configure o webhook no Bugsnag" -ForegroundColor White
Write-Host "4. Teste o fluxo com um erro de teste" -ForegroundColor White 