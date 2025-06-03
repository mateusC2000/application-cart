# 🛒 Shopping Cart API

Esta API permite gerenciar um carrinho de compras, incluindo funcionalidades para adicionar, visualizar e remover itens.

---

## 📌 Endpoints

### ➕ Adicionar Item ao Carrinho

Adiciona um produto ao carrinho com a quantidade especificada.

**Requisição:**  
`POST http://localhost:3000/cart/add_item`

**Corpo (JSON):**
```json
{
  "product_id": 229,
  "quantity": 2
}
```

**Resposta de Sucesso (200 OK):**
```json
{
  "id": 95,
  "products": [
    {
      "id": 228,
      "name": "iPhone 15 Pro Max",
      "quantity": 1,
      "unit_price": 14999.99,
      "total_price": 14999.99
    },
    {
      "id": 229,
      "name": "Xiamo Mi 27 Pro Plus Master Ultra",
      "quantity": 2,
      "unit_price": 999.99,
      "total_price": 1999.98
    }
  ],
  "total_price": 16999.97
}
```

**Possíveis Erros:**
- `404 Not Found`: Produto não existe.
- `422 Unprocessable Entity`: Argumentos inválidos (ex: quantidade negativa).

---

### 👀 Visualizar Carrinho

Retorna o conteúdo atual do carrinho de compras.

**Requisição:**  
`GET http://localhost:3000/cart`

**Resposta de Sucesso (200 OK):**
```json
{
  "id": 95,
  "products": [
    {
      "id": 228,
      "name": "iPhone 15 Pro Max",
      "quantity": 1,
      "unit_price": 14999.99,
      "total_price": 14999.99
    },
    {
      "id": 229,
      "name": "Xiamo Mi 27 Pro Plus Master Ultra",
      "quantity": 2,
      "unit_price": 999.99,
      "total_price": 1999.98
    }
  ],
  "total_price": 16999.97
}
```

---

### ❌ Remover Item do Carrinho

Remove um produto específico do carrinho.

**Requisição:**  
`DELETE http://localhost:3000/cart/228`

**Resposta de Sucesso (200 OK):**
```json
{
  "id": 95,
  "products": [],
  "total_price": 0.0
}
```

**Possíveis Erros:**
- `404 Not Found`: Produto não está no carrinho.

---

## 🛠️ Desenvolvimento

### ▶️ Executando a Aplicação

```bash
make start
```

### ✅ Executando Testes

```bash
make test
```

### 💻 Acessando o Console Rails

```bash
make bash
```

---

A aplicação utiliza serviços especializados para as operações:

- `AddProductToCartService`
- `RemoveProductFromCartService`

---

## ⚙️ Configuração do Ambiente

O projeto utiliza Docker. O `Makefile` fornece atalhos úteis:

```makefile
bash:
	docker compose run --rm web bash

test:
	docker compose run --rm app bash -c "bundle exec rspec"

start:
	docker compose up
```

---

## 📝 Notas Adicionais

- O carrinho é persistido na **sessão do usuário**.
- O sistema calcula automaticamente o **preço total**.
- Há tratamento de erros para produtos não encontrados ou parâmetros inválidos.

---
