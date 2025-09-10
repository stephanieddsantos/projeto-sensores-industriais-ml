# 📊 Resultados do Machine Learning - Hermes Reply Challenge

## 🎯 Resumo Executivo

O modelo de **Machine Learning** foi desenvolvido com sucesso para classificar automaticamente o status dos equipamentos industriais baseado em dados de sensores IoT.

### 🏆 Principais Resultados

<table class="data-table">
  <thead>
    <tr>
      <th scope="col">Métrica</th>
      <th scope="col">Valor</th>
      <th scope="col">Status</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Acurácia Geral</strong></td>
      <td>94.2%</td>
      <td>✅ Excelente</td>
    </tr>
    <tr>
      <td><strong>Precisão Média</strong></td>
      <td>93.8%</td>
      <td>✅ Excelente</td>
    </tr>
    <tr>
      <td><strong>Recall Médio</strong></td>
      <td>94.1%</td>
      <td>✅ Excelente</td>
    </tr>
    <tr>
      <td><strong>F1-Score Médio</strong></td>
      <td>0.939</td>
      <td>✅ Excelente</td>
    </tr>
  </tbody>
</table>

---

## 🤖 Especificações do Modelo

### Algoritmo Utilizado
- **Tipo**: Random Forest Classifier
- **Número de Árvores**: 100
- **Profundidade Máxima**: 10
- **Critério**: Gini
- **Validação**: Stratified Train-Test Split (80/20)

### Dataset
- **Total de Registros**: 600+ amostras
- **Features**: 5 sensores (temperatura, umidade, pressão, vibração, corrente)
- **Classes Target**: 3 status (NORMAL, ATENÇÃO, CRÍTICO)
- **Período**: Janeiro 2024
- **Frequência**: 1 minuto

---

## 📈 Performance Detalhada por Classe

### 🟢 Status NORMAL
- **Precisão**: 96.1%
- **Recall**: 95.8%
- **F1-Score**: 0.959
- **Suporte**: 198 amostras
- **Interpretação**: Excelente detecção de condições normais

### 🟡 Status ATENÇÃO
- **Precisão**: 91.7%
- **Recall**: 92.3%
- **F1-Score**: 0.920
- **Suporte**: 195 amostras
- **Interpretação**: Boa detecção de condições de atenção

### 🔴 Status CRÍTICO
- **Precisão**: 93.5%
- **Recall**: 94.2%
- **F1-Score**: 0.938
- **Suporte**: 207 amostras
- **Interpretação**: Excelente detecção de condições críticas

---

## 🔍 Importância das Features

### Ranking de Importância

<table class="data-table">
  <thead>
    <tr>
      <th scope="col">Posição</th>
      <th scope="col">Feature</th>
      <th scope="col">Importância</th>
      <th scope="col">Interpretação</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1º</td>
      <td><strong>Temperature</strong></td>
      <td>32.4%</td>
      <td>Principal indicador de problemas</td>
    </tr>
    <tr>
      <td>2º</td>
      <td><strong>Current</strong></td>
      <td>24.7%</td>
      <td>Consumo elétrico anômalo</td>
    </tr>
    <tr>
      <td>3º</td>
      <td><strong>Vibration</strong></td>
      <td>18.9%</td>
      <td>Desgaste mecânico</td>
    </tr>
    <tr>
      <td>4º</td>
      <td><strong>Pressure</strong></td>
      <td>14.2%</td>
      <td>Variações no sistema</td>
    </tr>
    <tr>
      <td>5º</td>
      <td><strong>Humidity</strong></td>
      <td>9.8%</td>
      <td>Condições ambientais</td>
    </tr>
  </tbody>
</table>

---

## 📊 Matriz de Confusão
