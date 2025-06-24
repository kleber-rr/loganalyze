# Guia Prático de Implementação - LogAnalyze n8n

## 🚀 Início Rápido

### 1. Pré-requisitos
- Docker e Docker Compose instalados
- Conta ativa no Bugsnag
- Conta ativa no ClickUp
- Token de API do ClickUp
- Bot do Telegram configurado (opcional, para notificações)

### 2. Configuração Inicial

```bash
# Clone o repositório (se aplicável)
git clone <seu-repositorio>
cd loganalyze_n8n

# Torne o script executável
chmod +x setup.sh
chmod +x test-webhook.sh

# Execute o setup
./setup.sh
```

### 3. Configuração das Credenciais

#### 3.1. Obter Token do ClickUp
1. Acesse: https://app.clickup.com/settings/apps
2. Clique em "Generate API Token"
3. Copie o token gerado

#### 3.2. Configurar Bot do Telegram (Opcional)
1. **Criar Bot:**
   - Abra o Telegram e procure por @BotFather
   - Envie `/newbot`
   - Siga as instruções para criar o bot
   - Copie o token do bot (ex: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

2. **Obter Chat ID:**
   - Adicione o bot ao chat/grupo onde quer receber notificações
   - Envie uma mensagem no chat
   - Acesse: `https://api.telegram.org/bot<SEU_TOKEN>/getUpdates`
   - Procure pelo `chat.id` na resposta

3. **Para Canais:**
   - Adicione o bot como administrador do canal
   - O chat ID será algo como `-1001234567890`

#### 3.3. Obter IDs dos Agentes
```bash
# Use este comando para listar usuários (substitua YOUR_TOKEN)
curl -H "Authorization: YOUR_TOKEN" \
  "https://api.clickup.com/api/v2/team" | jq '.teams[].members[] | {id: .user.id, name: .user.username}'
```

#### 3.4. Configurar arquivo .env
```bash
# Copie o arquivo de exemplo
cp env.example .env

# Edite o arquivo .env com suas credenciais
nano .env
```

### 4. Configuração do n8n

#### 4.1. Acessar o n8n
- URL: http://localhost:5678
- Usuário: admin
- Senha: admin123

#### 4.2. Configurar Credenciais
1. Vá em "Credentials" no menu lateral
2. Clique em "+" para adicionar nova credencial
3. **Para ClickUp:**
   - Selecione "ClickUp API"
   - Insira o token do ClickUp
   - Salve como "ClickUp API"
4. **Para Telegram (se usar):**
   - Selecione "Telegram API"
   - Insira o token do bot
   - Salve como "Telegram API"

#### 4.3. Importar Workflow
1. Vá em "Workflows" no menu lateral
2. Clique em "Import from file"
3. Selecione o arquivo `workflow.json`
4. Clique em "Import"

### 5. Configuração do Bugsnag

#### 5.1. Configurar Webhook
1. No Bugsnag, vá em "Project Settings" > "Integrations"
2. Procure por "Webhooks" ou "Data Forwarding"
3. Adicione novo webhook
4. URL: `http://localhost:5678/webhook/bugsnag-webhook`
5. Salve a configuração

#### 5.2. Testar Integração
```bash
# Execute o script de teste
./test-webhook.sh
```

### 6. Configuração do ClickUp

#### 6.1. Criar Estrutura de Status
No ClickUp, crie os seguintes status na sua lista:
- Recebimento
- Análise
- Rascunho
- Revisão
- Refinamento
- Criação
- Concluído

#### 6.2. Configurar Custom Fields (Opcional)
Adicione campos customizados:
- `severity` (texto)
- `error_url` (texto)
- `project_id` (texto)
- `error_id` (texto)
- `timestamp` (data)

### 7. Teste Completo

#### 7.1. Teste Manual
```bash
# Teste o webhook
./test-webhook.sh

# Verifique os logs
docker-compose logs -f n8n
```

#### 7.2. Verificações
1. ✅ Tarefa criada no ClickUp
2. ✅ Status correto atribuído
3. ✅ Agente correto atribuído
4. ✅ Notificação enviada no Telegram (se configurado)
5. ✅ Dados do erro mapeados corretamente

## 🔧 Troubleshooting

### Problema: n8n não inicia
```bash
# Verificar logs
docker-compose logs n8n

# Reiniciar container
docker-compose restart n8n
```

### Problema: Webhook não recebe dados
```bash
# Verificar se o webhook está ativo
curl http://localhost:5678/webhook/bugsnag-webhook

# Verificar logs do n8n
docker-compose logs -f n8n
```

### Problema: Erro de credenciais ClickUp
1. Verifique se o token está correto
2. Verifique se o token tem permissões adequadas
3. Teste a API diretamente:
```bash
curl -H "Authorization: YOUR_TOKEN" \
  "https://api.clickup.com/api/v2/user"
```

### Problema: Telegram não envia mensagens
1. Verifique se o bot token está correto
2. Verifique se o chat ID está correto
3. Teste a API do Telegram:
```bash
curl "https://api.telegram.org/bot<SEU_TOKEN>/sendMessage" \
  -d "chat_id=<SEU_CHAT_ID>" \
  -d "text=Teste de mensagem"
```

### Problema: IDs de agentes incorretos
```bash
# Listar todos os usuários
curl -H "Authorization: YOUR_TOKEN" \
  "https://api.clickup.com/api/v2/team" | jq '.teams[].members[] | {id: .user.id, name: .user.username, email: .user.email}'
```

## 📊 Monitoramento

### Logs do n8n
```bash
# Ver logs em tempo real
docker-compose logs -f n8n

# Ver logs das últimas 100 linhas
docker-compose logs --tail=100 n8n
```

### Métricas de Execução
- Acesse: http://localhost:5678/executions
- Monitore execuções bem-sucedidas vs falhas
- Verifique tempo de execução

### Alertas
Configure alertas para:
- Falhas de execução do workflow
- Tempo de resposta alto
- Erros de credenciais

## 🔄 Manutenção

### Backup
```bash
# Backup dos dados do n8n
docker run --rm -v loganalyze_n8n_n8n_data:/data -v $(pwd):/backup alpine tar czf /backup/n8n-backup-$(date +%Y%m%d).tar.gz -C /data .
```

### Atualização
```bash
# Atualizar n8n
docker-compose pull
docker-compose up -d
```

### Limpeza
```bash
# Limpar logs antigos
docker-compose logs --tail=1000 n8n > n8n-logs-$(date +%Y%m%d).log
docker-compose logs --tail=0 n8n
```

## 🚨 Cenários de Emergência

### n8n Indisponível
1. Verificar se o container está rodando: `docker-compose ps`
2. Reiniciar: `docker-compose restart n8n`
3. Se persistir, verificar logs: `docker-compose logs n8n`

### Bugsnag Não Enviando Dados
1. Verificar configuração do webhook no Bugsnag
2. Testar webhook manualmente: `./test-webhook.sh`
3. Verificar se a URL está acessível externamente

### ClickUp API Indisponível
1. Verificar status da API: https://status.clickup.com/
2. Verificar token de API
3. Implementar retry logic no workflow

### Telegram Indisponível
1. Verificar status da API: https://api.telegram.org/
2. Verificar token do bot
3. Verificar se o bot não foi bloqueado

## 📈 Otimizações

### Performance
- Monitorar tempo de execução do workflow
- Otimizar queries do ClickUp
- Implementar cache quando apropriado

### Escalabilidade
- Considerar múltiplas instâncias do n8n
- Implementar load balancing
- Usar banco de dados externo para n8n

### Segurança
- Usar HTTPS em produção
- Implementar autenticação forte
- Rotacionar tokens regularmente
- Monitorar logs de acesso

## 💡 Vantagens do Telegram vs Slack

### Telegram
- ✅ **Gratuito** sem limitações
- ✅ **Fácil configuração** (apenas bot token + chat ID)
- ✅ **Suporte nativo** no n8n
- ✅ **Notificações push** no celular
- ✅ **Grupos e canais** ilimitados
- ✅ **API estável** e bem documentada

### Slack
- ❌ **Limitações** no plano gratuito
- ❌ **Configuração mais complexa** (webhook URLs)
- ❌ **Dependência** de workspace
- ❌ **Rate limits** mais restritivos

## 🔧 Configuração Avançada do Telegram

### Múltiplos Chats
Para enviar notificações para múltiplos chats, você pode:
1. Criar múltiplos nós Telegram no workflow
2. Usar uma lista de chat IDs no n8n
3. Configurar diferentes tipos de notificação para diferentes chats

### Formatação de Mensagens
O Telegram suporta Markdown e HTML. Exemplos:
```javascript
// Markdown
"**Título em negrito**\n`código`\n[Link](https://exemplo.com)"

// HTML
"<b>Título em negrito</b>\n<code>código</code>\n<a href='https://exemplo.com'>Link</a>"
```

### Inline Keyboards
Para adicionar botões nas mensagens:
```javascript
{
  "text": "Mensagem com botões",
  "reply_markup": {
    "inline_keyboard": [
      [
        {"text": "Ver no ClickUp", "url": "https://app.clickup.com/t/123"},
        {"text": "Marcar como Resolvido", "callback_data": "resolve_123"}
      ]
    ]
  }
}
```

# Implementação do Sistema de Análise de Logs com AI Agents

## Visão Geral

Este projeto implementa um sistema automatizado de análise de logs de erro usando AI Agents, integrando Bugsnag, n8n, ClickUp e Telegram. O sistema utiliza três provedores de AI Agents para diferentes etapas do processamento.

## Arquitetura do Sistema

### Fluxo de Processamento com AI Agents

1. **Recebimento** (Gemini) - Recebe e classifica erros do Bugsnag
2. **Análise** (DeepSeek) - Analisa profundamente o erro e contexto
3. **Rascunho** (Ollama) - Cria rascunho inicial da tarefa
4. **Revisão** (Gemini) - Revisa e valida o rascunho
5. **Refinamento** (DeepSeek) - Melhora e refina a descrição
6. **Criação** (Ollama) - Cria a tarefa final no ClickUp
7. **Notificação** (Gemini) - Envia notificação via Telegram

## Pré-requisitos

### 1. Contas e APIs Necessárias
- **Bugsnag**: Conta e API Token
- **ClickUp**: Conta, API Token, Workspace ID, Space ID, List ID
- **Telegram**: Bot Token e Chat ID
- **Google Gemini**: API Key (gratuita)
- **Ollama**: Instalação local (gratuito)

### 2. Software Necessário
- **Docker**: Para rodar o n8n
- **Ollama**: Para modelos locais de AI
- **PowerShell**: Para scripts de configuração

## Configuração

### 1. Configuração do Ambiente

Copie o arquivo de exemplo e configure as variáveis:

```bash
cp env.example .env
```

Configure as seguintes variáveis no arquivo `.env`:

#### Configurações do n8n
```env
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=admin123
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
```

#### Configurações do Bugsnag
```env
BUGSNAG_API_TOKEN=your_bugsnag_api_token_here
BUGSNAG_PROJECT_ID=your_project_id_here
```

#### Configurações do ClickUp
```env
CLICKUP_API_TOKEN=your_clickup_api_token_here
CLICKUP_WORKSPACE_ID=your_workspace_id_here
CLICKUP_SPACE_ID=your_space_id_here
CLICKUP_LIST_ID=your_list_id_here
```

#### Configurações de AI Agents - Google Gemini
```env
GEMINI_API_KEY=your_gemini_api_key_here
GEMINI_MODEL=gemini-2.0-flash-exp
GEMINI_MAX_TOKENS=8192
```

#### Configurações de AI Agents - DeepSeek (via Ollama)
```env
OLLAMA_HOST=http://localhost:11434
DEEPSEEK_MODEL=deepseek-coder:6.7b
DEEPSEEK_MAX_TOKENS=4096
```

#### Configurações de AI Agents - Ollama Local
```env
OLLAMA_MODEL_ANALYSIS=llama3.2:3b
OLLAMA_MODEL_GENERATION=mistral:7b
OLLAMA_MODEL_REVIEW=codellama:7b
```

#### Configurações de Notificação - Telegram
```env
TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here
TELEGRAM_CHANNEL_ID=your_channel_id_here
```

### 2. Instalação e Configuração do Ollama

Execute o script de configuração do Ollama:

```powershell
powershell -ExecutionPolicy Bypass -File setup-ollama.ps1
```

Este script irá:
- Verificar se o Ollama está instalado
- Iniciar o serviço Ollama
- Baixar os modelos necessários:
  - `deepseek-coder:6.7b` (para análise técnica)
  - `llama3.2:3b` (para análise geral)
  - `mistral:7b` (para geração de conteúdo)
  - `codellama:7b` (para revisão de código)

### 3. Obtenção das Chaves de API

#### Google Gemini API Key
1. Acesse [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Crie uma nova API Key
3. Copie a chave para `GEMINI_API_KEY` no arquivo `.env`

#### Bugsnag API Token
1. Acesse [Bugsnag](https://app.bugsnag.com)
2. Vá em Settings > API Keys
3. Crie um novo API Token
4. Copie o token para `BUGSNAG_API_TOKEN` no arquivo `.env`

#### ClickUp API Token
1. Acesse [ClickUp](https://app.clickup.com)
2. Vá em Settings > Apps
3. Crie um novo Personal Token
4. Copie o token para `CLICKUP_API_TOKEN` no arquivo `.env`

### 4. Configuração do Telegram Bot

1. Crie um bot no Telegram:
   - Converse com [@BotFather](https://t.me/botfather)
   - Use o comando `/newbot`
   - Siga as instruções para criar o bot
   - Copie o token para `TELEGRAM_BOT_TOKEN`

2. Obtenha o Chat ID:
   - Adicione o bot ao grupo desejado
   - Execute o script de teste:
   ```powershell
   powershell -ExecutionPolicy Bypass -File test-telegram-bot.ps1
   ```
   - Copie o Chat ID para `TELEGRAM_CHAT_ID`

### 5. Teste dos AI Agents

Execute o script de teste para verificar se todos os AI Agents estão funcionando:

```powershell
powershell -ExecutionPolicy Bypass -File test-ai-agents.ps1
```

## Instalação do n8n

### 1. Iniciar o n8n via Docker

```bash
docker-compose up -d
```

### 2. Acessar o n8n

Abra o navegador e acesse: `http://localhost:5678`

- Usuário: `admin`
- Senha: `admin123`

### 3. Importar o Workflow

1. No n8n, vá em "Workflows"
2. Clique em "Import from file"
3. Selecione o arquivo `workflow.json`
4. O workflow será importado com todas as configurações dos AI Agents

## Configuração do Bugsnag Webhook

### 1. Configurar Webhook no Bugsnag

1. Acesse [Bugsnag](https://app.bugsnag.com)
2. Vá em Settings > Integrations
3. Clique em "Webhooks"
4. Adicione um novo webhook:
   - **URL**: `http://localhost:5678/webhook/bugsnag`
   - **Events**: Selecione "Error reports"
   - **Projects**: Selecione o projeto desejado

### 2. Testar o Webhook

Execute o script de teste:

```bash
./test-webhook.sh
```

## Funcionamento do Sistema

### 1. Fluxo de Processamento

1. **Erro detectado no Bugsnag**
   - Bugsnag envia webhook para n8n
   - n8n recebe os dados do erro

2. **Agente de Recebimento (Gemini)**
   - Analisa o erro recebido
   - Classifica a severidade
   - Extrai informações relevantes

3. **Agente de Análise (DeepSeek)**
   - Analisa profundamente o contexto
   - Identifica possíveis causas
   - Sugere soluções técnicas

4. **Agente de Rascunho (Ollama)**
   - Cria rascunho inicial da tarefa
   - Define título e descrição básica

5. **Agente de Revisão (Gemini)**
   - Revisa o rascunho criado
   - Valida informações e formatação
   - Sugere melhorias

6. **Agente de Refinamento (DeepSeek)**
   - Melhora a descrição da tarefa
   - Adiciona contexto técnico
   - Define prioridade e labels

7. **Agente de Criação (Ollama)**
   - Cria a tarefa final no ClickUp
   - Define responsável e prazo
   - Adiciona anexos e links

8. **Agente de Notificação (Gemini)**
   - Envia notificação via Telegram
   - Inclui resumo do erro e link da tarefa

### 2. Vantagens dos AI Agents

- **Automação completa**: Processamento sem intervenção humana
- **Análise inteligente**: Cada agente especializado em sua função
- **Redundância**: Múltiplos provedores para maior confiabilidade
- **Custo baixo**: Uso de modelos gratuitos e locais
- **Privacidade**: Processamento local com Ollama

## Monitoramento e Manutenção

### 1. Logs do Sistema

- **n8n**: Acesse `http://localhost:5678` para ver execuções
- **Ollama**: Logs disponíveis via `ollama logs`
- **Docker**: `docker-compose logs n8n`

### 2. Atualizações

- **Ollama**: `ollama pull [modelo]` para atualizar modelos
- **n8n**: `docker-compose pull && docker-compose up -d`
- **Workflow**: Reimporte o `workflow.json` se necessário

### 3. Backup

- **Workflow**: Exporte periodicamente do n8n
- **Configurações**: Backup do arquivo `.env`
- **Modelos**: Os modelos do Ollama ficam salvos localmente

## Troubleshooting

### Problemas Comuns

1. **Ollama não inicia**
   - Verifique se está instalado: `ollama --version`
   - Inicie manualmente: `ollama serve`

2. **Erro de API do Gemini**
   - Verifique se a API Key está correta
   - Confirme se tem créditos disponíveis

3. **Webhook não funciona**
   - Verifique se o n8n está rodando
   - Confirme a URL do webhook no Bugsnag

4. **Telegram não envia mensagens**
   - Verifique se o bot está no grupo
   - Confirme se tem permissões de envio

### Scripts de Diagnóstico

- `test-ai-agents.ps1`: Testa todos os AI Agents
- `test-telegram-bot.ps1`: Testa notificações do Telegram
- `test-webhook.sh`: Testa webhook do Bugsnag

## Próximos Passos

1. **Personalização**: Ajuste os prompts dos AI Agents conforme necessário
2. **Integração**: Adicione mais provedores de AI se necessário
3. **Monitoramento**: Implemente dashboards de monitoramento
4. **Escalabilidade**: Configure para múltiplos projetos/produtos 