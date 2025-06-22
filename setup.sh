#!/bin/bash

echo "🚀 Configurando LogAnalyze n8n - Automação de Análise de Logs"
echo "=========================================================="

# Verificar se Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não está instalado. Por favor, instale o Docker primeiro."
    exit 1
fi

# Verificar se Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro."
    exit 1
fi

echo "✅ Docker e Docker Compose encontrados"

# Criar diretório de configuração
mkdir -p n8n-config

# Verificar se arquivo .env existe
if [ ! -f .env ]; then
    echo "📝 Criando arquivo .env baseado no exemplo..."
    cp env.example .env
    echo "⚠️  IMPORTANTE: Configure as variáveis no arquivo .env antes de continuar!"
    echo "   - BUGSNAG_API_TOKEN"
    echo "   - CLICKUP_API_TOKEN"
    echo "   - IDs dos agentes"
    echo "   - Configurações de notificação"
    read -p "Pressione Enter após configurar o arquivo .env..."
fi

# Carregar variáveis de ambiente
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

echo "🔧 Iniciando n8n..."
docker-compose up -d

echo "⏳ Aguardando n8n inicializar..."
sleep 10

echo "✅ n8n iniciado com sucesso!"
echo "🌐 Acesse: http://localhost:5678"
echo "👤 Usuário: $N8N_BASIC_AUTH_USER"
echo "🔑 Senha: $N8N_BASIC_AUTH_PASSWORD"
echo ""
echo "📋 Próximos passos:"
echo "1. Acesse o n8n e configure as credenciais"
echo "2. Importe o fluxo de trabalho do arquivo workflow.json"
echo "3. Configure o webhook no Bugsnag"
echo "4. Teste o fluxo com um erro de teste" 