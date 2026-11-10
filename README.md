# 🚛 Transportadora SQL Join Lab

Um repositório prático para estudo e consolidação de conceitos essenciais e avançados em SQL:

* **`LEFT JOIN` vs `INNER JOIN`**
* **Anti-Joins** (Filtrando registros sem relacionamentos)
* **Agregações com `GROUP BY` e `HAVING`**
* **Tratamento de nulos com `COALESCE`**
* **Contagem condicional com `CASE WHEN`**
* **Diferenças fundamentais entre filtros na cláusula `ON` vs `WHERE`**

---

## 📌 Estrutura do Banco de Dados

O modelo simula o sistema de uma transportadora logística composto por **Motoristas** e **Entregas**:
```text
+--------------------+            +--------------------+
|     motorista      |            |      entrega       |
+--------------------+            +--------------------+
| id (PK)            |<-----------| id (PK)            |
| nome               | 1        N | codigo (UNIQUE)    |
| cnh                |            | destino            |
| cidade_base        |            | peso_kg            |
+--------------------+            | status             |
                                  | motorista_id (FK)  |
                                  +--------------------+


---

### Opção 2: Diagrama Renderizado Nativo do GitHub (Mermaid.js)
O GitHub renderiza o código abaixo automaticamente em um **gráfico interativo e visualmente moderno**:

```markdown
```mermaid
erDiagram
    motorista ||--o{ entrega : "possui (1:N)"

    motorista {
        int id PK
        string nome
        string cnh
        string cidade_base
    }

    entrega {
        int id PK
        string codigo UK
        string destino
        decimal peso_kg
        string status
        int motorista_id FK
    }
