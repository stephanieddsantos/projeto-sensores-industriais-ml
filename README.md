# 🏭 Sistema de Monitoramento Industrial com Sensores IoT e Machine Learning

[![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)](https://www.python.org/downloads/)
[![Oracle](https://img.shields.io/badge/Database-Oracle-red.svg)](https://www.oracle.com/)
[![Scikit-learn](https://img.shields.io/badge/ML-Scikit--learn-orange.svg)](https://scikit-learn.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📋 Descrição do Projeto

Este projeto foi desenvolvido como parte do **Desafio Hermes Reply - Fase 5**, focando na criação de um sistema completo de monitoramento industrial que integra:

- **Modelagem de Banco de Dados Relacional** para armazenamento eficiente de dados de sensores
- **Machine Learning** para análise preditiva e classificação de dados industriais
- **Visualizações interativas** para dashboard de monitoramento em tempo real

### 🎯 Objetivos

- Projetar um banco de dados normalizado e otimizado para dados de sensores IoT
- Implementar modelos de ML para predição e classificação de dados industriais
- Criar visualizações que auxiliem na tomada de decisões operacionais
- Desenvolver um sistema escalável para ambientes industriais reais

## 🏗️ Arquitetura do Sistema

### Cenário Industrial: Fábrica de Laticínios

**Empresa**: Laticínios Vale Verde Ltda  
**Setores Monitorados**:
- 🌡️ **Pasteurização** - Controle crítico de temperatura
- 🧪 **Fermentação** - Monitoramento de pH e temperatura
- 📦 **Embalagem** - Controle de vibração e velocidade
- ❄️ **Refrigeração** - Temperatura e umidade das câmaras frias

### Sensores Implementados

| Tipo de Sensor | Quantidade | Frequência de Leitura | Criticidade |
|----------------|------------|----------------------|-------------|
| Temperatura    | 15 unidades| 30 segundos          | CRÍTICA     |
| Pressão        | 8 unidades | 60 segundos          | ALTA        |
| pH             | 5 unidades | 120 segundos         | ALTA        |
| Umidade        | 10 unidades| 60 segundos          | MÉDIA       |
| Vibração       | 6 unidades | 30 segundos          | MÉDIA       |

## 🗄️ Modelagem do Banco de Dados

### Diagrama Entidade-Relacionamento

![Diagrama ER](database/diagrama_er.png)

### Principais Entidades

#### 🏢 **EMPRESA**
Cadastro das empresas proprietárias das unidades fabris
- `id_empresa` (PK)
- `razao_social`, `cnpj`, `endereco_completo`

#### 🏭 **UNIDADE_FABRIL** 
Unidades fabris de cada empresa
- `id_unidade` (PK), `id_empresa` (FK)
- `nome_unidade`, `capacidade_producao`

#### 🔧 **EQUIPAMENTO**
Equipamentos físicos instalados nos setores
- `id_equipamento` (PK), `id_setor` (FK)
- `numero_serie`, `status_operacional`

#### 📡 **SENSOR**
Sensores físicos instalados nos equipamentos
- `id_sensor` (PK), `id_equipamento` (FK)
- `numero_serie_sensor`, `localizacao_especifica`

#### 📊 **LEITURA_SENSOR** (Tabela Principal)
Dados coletados pelos sensores - **Particionada por data**
- `id_leitura` (PK), `id_sensor` (FK)
- `timestamp_leitura`, `valor_medido`, `valor_corrigido`

### Características Técnicas

- **Normalização**: 3ª Forma Normal aplicada
- **Particionamento**: Tabela de leituras particionada por trimestre
- **Índices Otimizados**: 8 índices estratégicos para consultas frequentes
- **Triggers Automáticos**: Validação e geração de alertas
- **Views Materializadas**: Para dashboards em tempo real

### Scripts SQL

- 📄 [`create_tables.sql`](database/create_tables.sql) - Criação completa do schema
- 📄 [`insert_sample_data.sql`](database/insert_sample_data.sql) - Dados de exemplo
- 📄 [`views_and_procedures.sql`](database/views_and_procedures.sql) - Views e procedures

## 🤖 Machine Learning

### Problemas Implementados

#### 1. 📈 **Classificação de Temperatura**
**Objetivo**: Classificar níveis de temperatura em "Baixa", "Normal", "Alta"

**Algoritmos Testados**:
- Random Forest (Melhor performance)
- SVM
- Gradient Boosting

**Métricas Obtidas**:
- **Acurácia**: 94.7%
- **Precisão**: 93.2%
- **Recall**: 94.1%
- **F1-Score**: 93.6%

#### 2. 🔮 **Predição de Valores Futuros**
**Objetivo**: Prever temperatura nas próximas 2 horas

**Algoritmo**: XGBoost Regressor
**Métricas**:
- **RMSE**: 1.23°C
- **MAE**: 0.87°C
- **R²**: 0.91

#### 3. ⚠️ **Detecção de Anomalias**
**Objetivo**: Identificar comportamentos anômalos nos sensores

**Algoritmo**: Isolation Forest
**Resultados**: 97.3% de precisão na detecção

### Dataset

- **Total de Registros**: 125.000 leituras
- **Período**: Janeiro 2024 - Dezembro 2024
- **Sensores**: 44 sensores ativos
- **Frequência**: Leituras a cada 30-120 segundos

### Notebooks Jupyter

1. 📊 [`01_exploratory_analysis.ipynb`](machine_learning/notebooks/01_exploratory_analysis.ipynb)
2. 🔧 [`02_data_preprocessing.ipynb`](machine_learning/notebooks/02_data_preprocessing.ipynb)
3. 🎯 [`03_model_training.ipynb`](machine_learning/notebooks/03_model_training.ipynb)

## 📈 Resultados e Visualizações

### Dashboard Principal

![Dashboard](results/screenshots/dashboard_principal.png)

### Gráficos de Performance

| Visualização | Descrição | Arquivo |
|-------------|-----------|---------|
| Matriz de Confusão | Classificação de temperatura | [`confusion_matrix.png`](results/charts/confusion_matrix.png) |
| Série Temporal | Evolução das temperaturas | [`temperature_timeline.png`](results/charts/temperature_timeline.png) |
| Distribuição de Dados | Histogramas por sensor | [`data_distribution.png`](results/charts/data_distribution.png) |
| Correlação | Heatmap de correlações | [`correlation_heatmap.png`](results/charts/correlation_heatmap.png) |

### Relatórios Técnicos

- 📄 [Documentação Técnica Completa](documentation/technical_documentation.md)
- 📄 [Manual do Usuário](documentation/user_manual.md)
- 📄 [Apresentação do Projeto](documentation/project_presentation.pdf)

## 🚀 Como Executar o Projeto

### Pré-requisitos

```bash
# Python 3.9 ou superior
python --version

# Oracle Database (ou Docker)
docker run -d -p 1521:1521 --name oracle-db oracle/database:19.3.0-ee
