
# GeoHub

GeoHub é uma plataforma **local-first** de dados geográficos construída em **Swift + Vapor**.
Ela fornece uma API para **descoberta, organização e uso de dados geoespaciais** por meio do padrão
**STAC (SpatioTemporal Asset Catalog)**, começando pela **Microsoft Planetary Computer**.

O objetivo do projeto é reduzir o tempo gasto em:
- encontrar datasets geográficos,
- entender metadados e formatos,
- recortar dados para uma área de interesse (AOI),
- reproduzir análises e pipelines.

---

## Conceitos principais (explicação amigável)

### Backend
O backend é a aplicação que roda no servidor (neste caso, localmente no seu computador).
Ele recebe requisições, conversa com serviços externos, organiza dados e devolve respostas em JSON.

### API
Uma API é a forma de conversar com o backend.
Você envia requisições HTTP (por exemplo, `POST /stac/search`) e recebe respostas estruturadas (JSON).

### Endpoint
Um endpoint é um “endereço” específico da API, por exemplo:
- `GET /health`
- `POST /stac/search`

Cada endpoint executa uma função específica do sistema.

### STAC (SpatioTemporal Asset Catalog)
STAC é um **padrão aberto** para catalogar dados geoespaciais.
Ele descreve:
- onde o dado está localizado (região geográfica),
- quando foi coletado (tempo),
- quais arquivos existem (assets) e como acessá-los.

Importante:
> STAC **não é o dado em si**, mas sim o **catálogo e os metadados** que apontam para o dado real.

### Microsoft Planetary Computer
A Planetary Computer hospeda grandes volumes de dados públicos (satélite, clima, uso do solo, etc.)
e fornece acesso a eles via uma API STAC padronizada.

---

## Funcionalidades implementadas (estado atual)

### `GET /health`
Endpoint simples para verificar se o servidor está rodando.

Exemplo de resposta:
```json
{
  "status": "ok",
  "timestamp": "2025-12-23T23:08:48Z"
}
```

### `POST /stac/search`
Realiza uma busca tipada (100% tipada em Swift) no catálogo STAC da Planetary Computer
e retorna o JSON bruto do STAC.

Exemplo de requisição:
```bash
curl -X POST http://localhost:8080/stac/search \
  -H "Content-Type: application/json" \
  -d '{
    "collections": ["sentinel-2-l2a"],
    "bbox": [-43.8, -23.1, -43.1, -22.7],
    "datetime": "2025-01-01/2025-01-31",
    "limit": 5
  }'
```

Resposta típica:
```json
{
  "type": "FeatureCollection",
  "...": "..."
}
```

---

## Estrutura do projeto

```
Sources/GeoHub/
├── App/
│   └── Controllers/
│       ├── HealthController.swift
│       └── StacController.swift
│
├── Core/
│   └── Stac/
│       ├── StacModels.swift
│       └── StacClient.swift
│
├── routes.swift
└── ...
```

### Organização
- **App/**: camada web (Vapor, controllers, rotas, HTTP).
- **Core/**: lógica de domínio e clientes externos (portável).
- **Services/** (futuro): storage, jobs, cache, engines de processamento.

---

## Requisitos

- macOS (Apple Silicon funciona normalmente)
- Xcode (toolchain Swift)
- Homebrew (recomendado)
- `entr` (opcional, para auto-restart em desenvolvimento)

---

## Como rodar o projeto

### Instalar dependência opcional (auto-restart)
```bash
brew install entr
```

### Rodar em modo desenvolvimento (auto-restart)
```bash
make dev
```

### Rodar apenas uma vez
```bash
make run
```

Servidor disponível em:
```
http://127.0.0.1:8080
```

---

## Comandos úteis

- `make dev`   → roda o servidor com reinício automático
- `make run`   → roda o servidor uma vez
- `make test`  → executa testes
- `make fmt`   → formata o código (requer swift-format)
- `make clean` → limpa artifacts de build

---

## Próximos passos (planejados)

- Normalização dos resultados STAC em modelos internos (`Dataset`)
- Persistência local (JSON → SQLite)
- Sistema de jobs para operações demoradas (recorte, estatísticas)
- Visualização geográfica (Leaflet, tiles XYZ)
- Integração opcional com engine Python para geoprocessamento pesado

---

## Licença
Projeto educacional / experimental para aprendizado e prototipagem.
