# Blue Fox IAM — Contexto para IA

SSO central do ecossistema: **Keycloak 26.6.1** + Postgres 16, com tema de login próprio. Não há código de aplicação, só configuração (compose, export do realm e tema FreeMarker).

- **Dev**: `http://localhost:8080/auth` (admin/admin) · **Prod**: `https://sso.bluefoxglobalgroup.com/auth` (atrás de proxy, `KC_PROXY_HEADERS=xforwarded`).
- Containers: `blue-fox-iam-server`, `blue-fox-iam-db`. O Postgres dev é exposto em `DB_PORT` (5434 no exemplo, para não colidir com os bancos dos outros projetos).

## Estrutura

```
realm-config/realm-export.json   # realm "blue-fox-global-group", importado com --import-realm (só no dev)
themes/bluefox-theme/login/
├── theme.properties             # parent=base, locales suportados
├── template.ftl / login.ftl     # layout e formulário de login
├── messages/messages_<loc>.properties   # pt-BR, pt, en, es, de, fr, it, ja, zh-CN, ko, ar, he
└── resources/{css/styles.css, js/lang-selector.js, img/logo.png}
```

## Clients do realm

| Client | Tipo | Origem |
| :--- | :--- | :--- |
| `blue-fox-aquariums-web` / `-local` | público (Angular) | `https://bluefoxaquarismo.space` / `http://localhost:4000` |
| `blue-fox-blog-backend` / `-local` | confidencial (NestJS) | `blog-api.bluefoxglobalgroup.com` / `localhost:8081` |
| `blue-fox-finance-web` / `-local` | público (Angular) | `finance.bluefoxglobalgroup.com` / `localhost:4200` |
| `blue-fox-finance-backend` / `-local` | confidencial (NestJS) | `finance-api.bluefoxglobalgroup.com` / `localhost:3000` |

Roles do realm: `ROLE_ADMIN`, `ROLE_USER`, `ROLE_AQUARIUM_ADMIN`, `ROLE_AQUARIUM_EDITOR`, `ROLE_AQUARIUM_USER`, `ROLE_FINANCE_ADMIN`, `ROLE_FINANCE_USER`.

## Regras

1. **Nova app no ecossistema = dois clients** (prod + `-local`) com `redirectUris`/`webOrigins` exatos. Atualize o `realm-export.json` **e** a tabela do README.
2. O `realm-export.json` só é importado na primeira subida de um banco vazio. Em produção as mudanças são feitas pelo console admin, e o export precisa ser re-gerado/editado para continuar sendo a fonte da verdade.
3. **Tema**: depois de mudar CSS/JS/imagem, incremente o cache-buster `?v=X.Y` no `template.ftl` (hoje `2.2`). No dev o cache de tema já vem desligado.
4. **i18n**: toda chave nova precisa existir em todos os `messages_*.properties`. Árabe (`ar`) e hebraico (`he`) são RTL e usam as fontes Cairo/Rubik; teste o layout em RTL (ícone de senha, padding dos inputs).
5. Visual segue a skill `bluefox-design-system`: fundo navy `#0b132b`/`#1c2541`, `logo_white.png`, botão com o gradiente oficial.

## Comandos

```bash
docker network create infra-net   # uma vez
docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file .env.dev up -d
docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file .env.prod up -d
```
