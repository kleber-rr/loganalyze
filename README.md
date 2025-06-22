# LogAnalyze n8n - Automação de Análise de Logs

Sistema completo de automação para análise de logs, integrando Bugsnag, n8n e ClickUp com fluxo de trabalho em múltiplas etapas e atribuição dinâmica de agentes.

## 🚀 Início Rápido

### Pré-requisitos
- Docker e Docker Compose
- Conta ativa no Bugsnag
- Conta ativa no ClickUp
- Token de API do ClickUp

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
2. Acesse o n8n: http://localhost:5678
3. Configure as credenciais do ClickUp
4. Importe o workflow: `workflow.json`
5. Configure o webhook no Bugsnag

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
7. **Notificação** - Conclusão e notificação

## 🧪 Testes

```bash
# Testar webhook
./test-webhook.sh

# Ver logs
docker-compose logs -f n8n
```

## 📚 Documentação

- [Guia de Implementação](IMPLEMENTACAO.md) - Passo-a-passo detalhado
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
| `SLACK_WEBHOOK_URL` | URL do webhook do Slack | `https://hooks.slack.com/...` |

### Status no ClickUp

Configure os seguintes status na sua lista:
- Recebimento
- Análise
- Rascunho
- Revisão
- Refinamento
- Criação
- Concluído

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