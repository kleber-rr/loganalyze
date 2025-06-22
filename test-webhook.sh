#!/bin/bash

# Script para testar o webhook do n8n simulando um payload do Bugsnag

echo "🧪 Testando Webhook do n8n - Simulação Bugsnag"
echo "=============================================="

# Verificar se o n8n está rodando
if ! curl -s http://localhost:5678 > /dev/null; then
    echo "❌ n8n não está rodando. Execute 'docker-compose up -d' primeiro."
    exit 1
fi

# URL do webhook (ajuste conforme necessário)
WEBHOOK_URL="http://localhost:5678/webhook/bugsnag-webhook"

# Payload de teste simulado do Bugsnag
PAYLOAD='{
  "error": {
    "id": "test-error-123",
    "message": "Erro de teste - TypeError: Cannot read property 'length' of undefined",
    "context": "test-context",
    "stacktrace": "TypeError: Cannot read property 'length' of undefined\n    at processData (/app/src/utils.js:45:12)\n    at handleRequest (/app/src/controller.js:23:8)",
    "url": "https://app.example.com/dashboard"
  },
  "project": {
    "id": "test-project-456",
    "name": "Test Project"
  },
  "severity": "error",
  "receivedAt": "'$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")'",
  "user": {
    "id": "user-123",
    "email": "test@example.com"
  },
  "device": {
    "osName": "Windows",
    "osVersion": "10.0.19044"
  }
}'

echo "📤 Enviando payload de teste para: $WEBHOOK_URL"
echo "📋 Payload:"
echo "$PAYLOAD" | jq '.' 2>/dev/null || echo "$PAYLOAD"

# Enviar requisição
RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X POST \
  -H "Content-Type: application/json" \
  -H "X-Bugsnag-Signature: test-signature" \
  -d "$PAYLOAD" \
  "$WEBHOOK_URL")

# Separar resposta e código HTTP
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
RESPONSE_BODY=$(echo "$RESPONSE" | head -n -1)

echo ""
echo "📥 Resposta:"
echo "HTTP Code: $HTTP_CODE"

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Webhook executado com sucesso!"
    echo "📄 Resposta do n8n:"
    echo "$RESPONSE_BODY" | jq '.' 2>/dev/null || echo "$RESPONSE_BODY"
else
    echo "❌ Erro na execução do webhook"
    echo "📄 Resposta de erro:"
    echo "$RESPONSE_BODY"
fi

echo ""
echo "🔍 Verifique no ClickUp se a tarefa foi criada:"
echo "   https://app.clickup.com/"
echo ""
echo "🔍 Verifique os logs do n8n:"
echo "   docker-compose logs -f n8n" 