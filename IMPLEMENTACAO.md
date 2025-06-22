# Guia Prático de Implementação - LogAnalyze n8n

## 🚀 Início Rápido

### 1. Pré-requisitos
- Docker e Docker Compose instalados
- Conta ativa no Bugsnag
- Conta ativa no ClickUp
- Token de API do ClickUp
- IDs dos agentes no ClickUp

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

#### 3.2. Obter IDs dos Agentes
```bash
# Use este comando para listar usuários (substitua YOUR_TOKEN)
curl -H "Authorization: YOUR_TOKEN" \
  "https://api.clickup.com/api/v2/team" | jq '.teams[].members[] | {id: .user.id, name: .user.username}'
```

#### 3.3. Configurar arquivo .env
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
3. Selecione "ClickUp API"
4. Insira o token do ClickUp
5. Salve como "ClickUp API"

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
4. ✅ Notificação enviada (se configurada)
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