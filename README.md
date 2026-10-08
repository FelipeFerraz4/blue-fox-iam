# Blue Fox IAM (Identity and Access Management)

Repositório centralizado de autenticação e autorização baseado em **Keycloak**.

---

## 🛠️ Desenvolvimento (Dev)

1. Crie a rede compartilhada (se ainda não existir):
   ```bash
   docker network create infra-net
   ```
2. Crie o arquivo de variáveis a partir do exemplo:
   ```bash
   cp .env.dev.example .env.dev
   ```
3. Suba o ambiente de desenvolvimento:
   ```bash
   docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev up -d
   ```
4. Acesse em: `http://localhost:8080/auth`

Para parar o ambiente de desenvolvimento:
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev down
```

---

## 🚀 Produção (Prod)

1. Crie a rede compartilhada de infraestrutura (se ainda não existir):
   ```bash
   docker network create infra-net
   ```
2. Configure o arquivo `.env.prod`:
   ```bash
   cp .env.prod.example .env.prod
   # Edite com as senhas e configurações seguras de produção
   ```
3. Suba o ambiente de produção:
   ```bash
   docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod up -d
   ```

Para parar o ambiente de produção:
```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod down
```

---

## ⚙️ Configuração Inicial Recomendada
- **Realm:** `blue-fox-global-group`
- **Clients:**
  - `blue-fox-aquariums-web` / `blue-fox-aquariums-web-local`: (Public - Angular)
  - `blue-fox-blog-backend` / `blue-fox-blog-backend-local`: (Confidential - NestJS)
  - `blue-fox-finance-web` / `blue-fox-finance-web-local`: (Public - Angular)
  - `blue-fox-finance-backend` / `blue-fox-finance-backend-local`: (Confidential - NestJS)
- **Roles:**
  - `ROLE_ADMIN`: Administrador global do grupo Blue Fox.
  - `ROLE_USER`: Usuário geral autenticado.
  - `ROLE_AQUARIUM_ADMIN` / `ROLE_AQUARIUM_EDITOR` / `ROLE_AQUARIUM_USER`: Gestão de artigos e conteúdos do Aquarismo.
  - `ROLE_FINANCE_ADMIN` / `ROLE_FINANCE_USER`: Gestão de transações e relatórios financeiros.