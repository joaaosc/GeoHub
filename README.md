# GeoHub

GeoHub é uma plataforma **local-first** de dados geográficos construída em **Swift + Vapor**. Ela expõe uma API para **descoberta, organização e uso de dados geoespaciais** via **STAC (SpatioTemporal Asset Catalog)**, começando pela **Microsoft Planetary Computer**.

O objetivo é reduzir tempo gasto em:
- encontrar datasets geográficos,
- entender metadados e formatos,
- recortar dados para uma área de interesse (AOI),
- reproduzir análises e pipelines.

---

## Conceitos principais (explicação amigável)

### Backend
Aplicação que roda no servidor (aqui, localmente no seu computador) e expõe endpoints HTTP.

### API
Interface para conversar com o backend via HTTP. Você envia requisições e recebe respostas JSON.

### Endpoint
Caminho específico da API, por exemplo: `GET /health` ou `POST /stac/search`.

### STAC (SpatioTemporal Asset Catalog)
STAC é um **padrão aberto** para catalogar dados geoespaciais no tempo e no espaço. Ele descreve:
- onde o dado está (região geográfica),
- quando foi capturado (tempo),
- quais arquivos existem (assets) e como acessá-los (links/URLs).

Importante:
> STAC **não é** o dado (imagem/raster) em si; é o **catálogo/metadata** que aponta para os dados reais.

### Microsoft Planetary Computer
Plataforma que disponibiliza muitos datasets públicos (satélite, clima, uso do solo etc.) e oferece uma API STAC para busca.

---

## Funcionalidades implementadas (estado atual)

### Página inicial (UI estática)
- `GET /` serve `Public/index.html` como página padrão.
- `GET /index.html` também funciona.

Observação:
- O Vapor não faz “index automático” por padrão. Para que `/` sirva `index.html`, existe uma rota explícita em `routes.swift`.
- O `FileMiddleware` também está habilitado para servir arquivos estáticos em `Public/` (útil para JS/CSS no futuro).

### Saúde do servidor
- `GET /health` retorna um JSON simples com status e timestamp.

Exemplo:
```json
{
  "status": "ok",
  "timestamp": "2025-12-23T23:08:48Z"
}
```

### Busca STAC + normalização + persistência local
- `POST /stac/search`:
  1) busca no STAC da Planetary Computer
  2) salva o JSON bruto em `data/raw/<datasetId>.json`
  3) normaliza para um modelo interno (`Dataset`)
  4) salva em `data/datasets/<datasetId>.json`
  5) retorna o `Dataset` normalizado

### Catálogo local (datasets persistidos)
- `GET /datasets` lista datasets salvos localmente.
- `GET /datasets/:id` retorna um dataset específico.

---

## Estrutura do projeto (alto nível)

```
GeoHub/
├── Public/
│   └── index.html                 # página inicial
├── Sources/GeoHub/
│   ├── App/
│   │   └── Controllers/           # endpoints HTTP (camada web)
│   ├── Core/                      # modelos + STAC + normalização (camada de domínio)
│   ├── Services/                  # storage e infra (camada de serviços)
│   └── routes.swift               # registro de rotas
├── data/
│   ├── raw/                       # JSON bruto do STAC (gerado em runtime)
│   └── datasets/                  # Dataset normalizado (gerado em runtime)
├── Makefile
└── scripts/
```

---

## Requisitos

- macOS (Apple Silicon funciona)
- Xcode (toolchain Swift)
- Homebrew (recomendado)
- `entr` (recomendado, para auto-restart em desenvolvimento)

---

## Como rodar

### 1) Instalar dependência de desenvolvimento (auto-restart)
```bash
brew install entr
```

### 2) Rodar em modo desenvolvimento (auto-restart)
```bash
make dev
```
Isso observa mudanças em `Sources/**/*.swift` e reinicia o servidor automaticamente.

### 3) Rodar apenas uma vez (sem watcher)
```bash
make run
```

Servidor por padrão:
- http://127.0.0.1:8080/

---

## Testes rápidos

### Página inicial
- http://127.0.0.1:8080/
- http://127.0.0.1:8080/index.html

### Health check
```bash
curl -s http://localhost:8080/health | jq
```

### Buscar no STAC e persistir localmente
```bash
curl -s -X POST http://localhost:8080/stac/search   -H "Content-Type: application/json"   -d '{
    "collections":["sentinel-2-l2a"],
    "bbox":[-43.8,-23.1,-43.1,-22.7],
    "datetime":"2025-01-01/2025-01-31",
    "limit":5
  }' | jq '.id, (.items | length)'
```

### Listar datasets locais
```bash
curl -s http://localhost:8080/datasets | jq 'length'
```

### Consultar dataset por id
```bash
curl -s http://localhost:8080/datasets/<ID_AQUI> | jq '.id, .source, (.items | length)'
```

---

## Dados gerados e Git

A pasta `data/` é **gerada em runtime** (a cada requisição), então **não deve ser versionada**.

Sugestão para `.gitignore`:
```gitignore
data/
.build/
.DS_Store
```

Se você quiser manter a pasta `data/` visível no repositório:
1) crie `data/.gitkeep`
2) ignore o restante:

```gitignore
data/*
!data/.gitkeep
```

---

## Próximos passos (planejados)

### Opção A — Visualização (Leaflet)
- UI em `Public/` para listar datasets (`GET /datasets`)
- desenhar `bbox`/footprints no mapa
- facilitar exploração de coleções e áreas de interesse

### Opção B — Jobs + engine Python (processamento)
- fila simples de jobs (assíncronos) para operações demoradas
- integração opcional com Python (rasterio/xarray/geopandas)
- operações típicas: recorte, estatísticas, geração de tiles

---

## Licença
Projeto educacional/experimental para prototipagem e aprendizado.
