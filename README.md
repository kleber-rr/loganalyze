# LogAnalyze n8n - Automação de Análise de Logs

Sistema completo de automação para análise de logs, integrando Bugsnag, n8n e ClickUp com fluxo de trabalho em múltiplas etapas e atribuição dinâmica de agentes. Notificações via Telegram para máxima simplicidade e eficiência.

## 🚀 Início Rápido

### Pré-requisitos
- Docker e Docker Compose
- Conta ativa no Bugsnag
- Conta ativa no ClickUp
- Token de API do ClickUp
- Bot do Telegram (opcional, para notificações)

### Instalação

#### Linux/macOS
```bash
chmod +x setup.sh
./setup.sh
```

#### Windows
```powershell
.\setup.ps1
```

### Configuração
1. Configure as variáveis no arquivo `.env`
2. Configure o bot do Telegram (opcional)
3. Acesse o n8n: http://localhost:5678
4. Configure as credenciais do ClickUp e Telegram
5. Importe o workflow: `workflow.json`
6. Configure o webhook no Bugsnag

## 📁 Estrutura do Projeto

```
loganalyze_n8n/
├── docker-compose.yml      # Configuração Docker
├── env.example             # Exemplo de variáveis de ambiente
├── setup.sh               # Script de setup (Linux/macOS)
├── setup.ps1              # Script de setup (Windows)
├── test-webhook.sh        # Script de teste do webhook
├── workflow.json          # Fluxo de trabalho n8n
├── IMPLEMENTACAO.md       # Guia detalhado de implementação
├── PROJETO.md             # Documentação técnica completa
└── readme.md              # Este arquivo
```

## 🔄 Fluxo de Trabalho

O sistema implementa um fluxo de 7 etapas:

1. **Recebimento** - Bugsnag envia erro via webhook
2. **Análise** - Agente analisa a causa raiz
3. **Rascunho** - Elaboração de solução
4. **Revisão** - Validação da solução
5. **Refinamento** - Ajustes finais
6. **Criação** - Implementação da solução
7. **Notificação** - Conclusão e notificação via Telegram

## 🧪 Testes

```bash
# Testar webhook
./test-webhook.sh

# Ver logs
docker-compose logs -f n8n
```

## 📚 Documentação

- [Guia de Implementação](IMPLEMENTACAO.md) - Passo-a-passo detalhado
- [Documentação Técnica](PROJETO.md) - Especificações completas
- [Troubleshooting](IMPLEMENTACAO.md#troubleshooting) - Solução de problemas
- [Monitoramento](IMPLEMENTACAO.md#monitoramento) - Como monitorar o sistema

## 🔧 Configuração Avançada

### Variáveis de Ambiente

| Variável | Descrição | Exemplo |
|----------|-----------|---------|
| `CLICKUP_API_TOKEN` | Token de API do ClickUp | `pk_123456_ABCDEF` |
| `CLICKUP_WORKSPACE_ID` | ID do workspace | `123456` |
| `CLICKUP_SPACE_ID` | ID do space | `789012` |
| `CLICKUP_LIST_ID` | ID da lista | `345678` |
| `AGENT_RECEBIMENTO_ID` | ID do agente de recebimento | `901234` |
| `TELEGRAM_BOT_TOKEN` | Token do bot do Telegram | `123456789:ABCdef...` |
| `TELEGRAM_CHAT_ID` | ID do chat/grupo | `123456789` |

### Status no ClickUp

Configure os seguintes status na sua lista:
- Recebimento
- Análise
- Rascunho
- Revisão
- Refinamento
- Criação
- Concluído

## 💬 Configuração do Telegram

### Vantagens do Telegram
- ✅ **Gratuito** sem limitações
- ✅ **Fácil configuração** (apenas bot token + chat ID)
- ✅ **Suporte nativo** no n8n
- ✅ **Notificações push** no celular
- ✅ **Grupos e canais** ilimitados

### Setup Rápido
1. Procure por @BotFather no Telegram
2. Envie `/newbot` e siga as instruções
3. Copie o token do bot
4. Adicione o bot ao chat/grupo desejado
5. Obtenha o chat ID via API

## 🚨 Cenários de Emergência

### n8n Indisponível
```bash
docker-compose restart n8n
docker-compose logs n8n
```

### Webhook Não Funciona
```bash
./test-webhook.sh
curl http://localhost:5678/webhook/bugsnag-webhook
```

### Erro de Credenciais
1. Verifique o token do ClickUp
2. Teste a API: `curl -H "Authorization: YOUR_TOKEN" "https://api.clickup.com/api/v2/user"`
3. Verifique permissões do token

### Telegram Não Funciona
```bash
curl "https://api.telegram.org/bot<SEU_TOKEN>/sendMessage" \
  -d "chat_id=<SEU_CHAT_ID>" \
  -d "text=Teste"
```

## 📊 Monitoramento

### Logs
```bash
# Tempo real
docker-compose logs -f n8n

# Últimas 100 linhas
docker-compose logs --tail=100 n8n
```

### Métricas
- Acesse: http://localhost:5678/executions
- Monitore execuções vs falhas
- Verifique tempo de resposta

## 🔄 Manutenção

### Backup
```bash
docker run --rm -v loganalyze_n8n_n8n_data:/data -v $(pwd):/backup alpine tar czf /backup/n8n-backup-$(date +%Y%m%d).tar.gz -C /data .
```

### Atualização
```bash
docker-compose pull
docker-compose up -d
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

---

**Desenvolvido com ❤️ para automação de análise de logs** 