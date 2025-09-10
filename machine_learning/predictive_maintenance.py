"""
Sistema de Manutenção Preditiva - Hermes Reply Challenge
Classificação de Status dos Equipamentos Industriais

Autor: Equipe Challenge Reply
Data: Janeiro 2025
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score
import warnings
warnings.filterwarnings('ignore')

class PredictiveMaintenance:
    """
    Classe principal para análise preditiva de manutenção industrial
    """
    
    def __init__(self):
        self.model = None
        self.scaler = StandardScaler()
        self.label_encoder = LabelEncoder()
        self.feature_names = None
        self.target_names = None
        
    def load_data(self, file_path='../data/sensor_data_sample.csv'):
        """
        Carrega e prepara os dados dos sensores
        """
        try:
            print("📊 Carregando dados dos sensores...")
            self.df = pd.read_csv(file_path)
            print(f"✅ Dados carregados: {len(self.df)} registros")
            print(f"📈 Colunas: {list(self.df.columns)}")
            return True
        except Exception as e:
            print(f"❌ Erro ao carregar dados: {e}")
            return False
    
    def explore_data(self):
        """
        Análise exploratória dos dados
        """
        print("\n" + "="*60)
        print("📊 ANÁLISE EXPLORATÓRIA DOS DADOS")
        print("="*60)
        
        # Informações básicas
        print("\n🔍 Informações Gerais:")
        print(f"• Total de registros: {len(self.df):,}")
        print(f"• Período: {self.df['timestamp'].min()} até {self.df['timestamp'].max()}")
        print(f"• Sensores únicos: {self.df['sensor_id'].nunique()}")
        print(f"• Equipamentos únicos: {self.df['equipment_id'].nunique()}")
        
        # Distribuição dos status
        print("\n📈 Distribuição dos Status:")
        status_counts = self.df['status'].value_counts()
        for status, count in status_counts.items():
            percentage = (count / len(self.df)) * 100
            print(f"• {status}: {count:,} ({percentage:.1f}%)")
        
        # Estatísticas dos sensores
        print("\n🌡️ Estatísticas dos Sensores:")
        numeric_cols = ['temperature', 'humidity', 'pressure', 'vibration', 'current']
        stats = self.df[numeric_cols].describe()
        print(stats.round(2))
        
        return status_counts
    
    def preprocess_data(self):
        """
        Pré-processamento dos dados para ML
        """
        print("\n🔧 Pré-processando dados para Machine Learning...")
        
        # Selecionando features numéricas
        self.feature_names = ['temperature', 'humidity', 'pressure', 'vibration', 'current']
        X = self.df[self.feature_names]
        
        # Target (status)
        y = self.df['status']
        self.target_names = y.unique()
        
        # Codificando o target
        y_encoded = self.label_encoder.fit_transform(y)
        
        # Dividindo em treino e teste
        self.X_train, self.X_test, self.y_train, self.y_test = train_test_split(
            X, y_encoded, test_size=0.2, random_state=42, stratify=y_encoded
        )
        
        # Normalizando as features
        self.X_train_scaled = self.scaler.fit_transform(self.X_train)
        self.X_test_scaled = self.scaler.transform(self.X_test)
        
        print(f"✅ Dados preparados:")
        print(f"• Treino: {len(self.X_train)} amostras")
        print(f"• Teste: {len(self.X_test)} amostras")
        print(f"• Features: {len(self.feature_names)}")
        print(f"• Classes: {len(self.target_names)}")
        
    def train_model(self):
        """
        Treina o modelo Random Forest
        """
        print("\n🤖 Treinando modelo Random Forest...")
        
        # Configurando o modelo
        self.model = RandomForestClassifier(
            n_estimators=100,
            max_depth=10,
            min_samples_split=5,
            min_samples_leaf=2,
            random_state=42
        )
        
        # Treinando
        self.model.fit(self.X_train_scaled, self.y_train)
        
        # Fazendo predições
        self.y_pred = self.model.predict(self.X_test_scaled)
        
        print("✅ Modelo treinado com sucesso!")
        
    def evaluate_model(self):
        """
        Avalia a performance do modelo
        """
        print("\n" + "="*60)
        print("📊 AVALIAÇÃO DO MODELO")
        print("="*60)
        
        # Accuracy
        accuracy = accuracy_score(self.y_test, self.y_pred)
        print(f"\n🎯 Acurácia Geral: {accuracy:.3f} ({accuracy*100:.1f}%)")
        
        # Relatório de classificação
        print("\n📋 Relatório Detalhado:")
        target_names = self.label_encoder.classes_
        report = classification_report(self.y_test, self.y_pred, 
                                     target_names=target_names, 
                                     output_dict=True)
        
        for class_name in target_names:
            metrics = report[class_name]
            print(f"• {class_name}:")
            print(f"  - Precisão: {metrics['precision']:.3f}")
            print(f"  - Recall: {metrics['recall']:.3f}")
            print(f"  - F1-Score: {metrics['f1-score']:.3f}")
        
        return accuracy, report
    
    def plot_confusion_matrix(self):
        """
        Plota a matriz de confusão
        """
        plt.figure(figsize=(10, 8))
        
        # Calculando matriz de confusão
        cm = confusion_matrix(self.y_test, self.y_pred)
        target_names = self.label_encoder.classes_
        
        # Plotando
        sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
                   xticklabels=target_names,
                   yticklabels=target_names)
        
        plt.title('Matriz de Confusão - Classificação de Status\n'
                 'Sistema de Manutenção Preditiva', fontsize=14, fontweight='bold')
        plt.xlabel('Status Predito', fontsize=12)
        plt.ylabel('Status Real', fontsize=12)
        plt.tight_layout()
        
        # Salvando
        plt.savefig('../results/confusion_matrix.png', dpi=300, bbox_inches='tight')
        print("💾 Matriz de confusão salva em: results/confusion_matrix.png")
        plt.show()
    
    def plot_feature_importance(self):
        """
        Plota a importância das features
        """
        plt.figure(figsize=(10, 6))
        
        # Obtendo importâncias
        importances = self.model.feature_importances_
        indices = np.argsort(importances)[::-1]
        
        # Plotando
        plt.bar(range(len(importances)), importances[indices])
        plt.title('Importância das Features\n'
                 'Modelo de Manutenção Preditiva', fontsize=14, fontweight='bold')
        plt.xlabel('Features dos Sensores', fontsize=12)
        plt.ylabel('Importância', fontsize=12)
        plt.xticks(range(len(importances)), 
                  [self.feature_names[i] for i in indices], rotation=45)
        
        # Adicionando valores
        for i, v in enumerate(importances[indices]):
            plt.text(i, v + 0.01, f'{v:.3f}', ha='center', va='bottom')
        
        plt.tight_layout()
        plt.savefig('../results/feature_importance.png', dpi=300, bbox_inches='tight')
        print("💾 Importância das features salva em: results/feature_importance.png")
        plt.show()
    
    def plot_sensor_trends(self):
        """
        Plota tendências dos sensores por status
        """
        fig, axes = plt.subplots(2, 3, figsize=(15, 10))
        axes = axes.ravel()
        
        numeric_cols = ['temperature', 'humidity', 'pressure', 'vibration', 'current']
        
        for i, col in enumerate(numeric_cols):
            sns.boxplot(data=self.df, x='status', y=col, ax=axes[i])
            axes[i].set_title(f'Distribuição: {col.title()}', fontweight='bold')
            axes[i].tick_params(axis='x', rotation=45)
        
        # Removendo subplot extra
        axes[5].remove()
        
        plt.suptitle('Análise de Sensores por Status do Equipamento\n'
                    'Sistema de Monitoramento Industrial', 
                    fontsize=16, fontweight='bold')
        plt.tight_layout()
        plt.savefig('../results/sensor_analysis.png', dpi=300, bbox_inches='tight')
        print("💾 Análise de sensores salva em: results/sensor_analysis.png")
        plt.show()
    
    def generate_predictions_sample(self):
        """
        Gera exemplos de predições
        """
        print("\n" + "="*60)
        print("🔮 EXEMPLOS DE PREDIÇÕES")
        print("="*60)
        
        # Pegando algumas amostras de teste
        sample_indices = np.random.choice(len(self.X_test), 5, replace=False)
        
        for i, idx in enumerate(sample_indices):
            # Dados reais
            real_features = self.X_test.iloc[idx]
            real_status = self.label_encoder.classes_[self.y_test[idx]]
            
            # Predição
            pred_features = self.X_test_scaled[idx].reshape(1, -1)
            pred_status_encoded = self.model.predict(pred_features)[0]
            pred_status = self.label_encoder.classes_[pred_status_encoded]
            
            # Probabilidades
            probabilities = self.model.predict_proba(pred_features)[0]
            
            print(f"\n🔧 Exemplo {i+1}:")
            print(f"• Temperatura: {real_features['temperature']:.1f}°C")
            print(f"• Umidade: {real_features['humidity']:.1f}%")
            print(f"• Pressão: {real_features['pressure']:.3f} bar")
            print(f"• Vibração: {real_features['vibration']:.2f} Hz")
            print(f"• Corrente: {real_features['current']:.1f} A")
            print(f"• Status Real: {real_status}")
            print(f"• Status Predito: {pred_status}")
            print(f"• Confiança: {max(probabilities):.1%}")
            
            if real_status == pred_status:
                print("✅ Predição CORRETA")
            else:
                print("❌ Predição INCORRETA")

def main():
    """
    Função principal - executa todo o pipeline
    """
    print("🚀 SISTEMA DE MANUTENÇÃO PREDITIVA - HERMES REPLY")
    print("="*60)
    
    # Inicializando o sistema
    pm = PredictiveMaintenance()
    
    # Carregando dados
    if not pm.load_data():
        return
    
    # Análise exploratória
    pm.explore_data()
    
    # Pré-processamento
    pm.preprocess_data()
    
    # Treinamento
    pm.train_model()
    
    # Avaliação
    accuracy, report = pm.evaluate_model()
    
    # Visualizações
    pm.plot_confusion_matrix()
    pm.plot_feature_importance()
    pm.plot_sensor_trends()
    
    # Exemplos de predições
    pm.generate_predictions_sample()
    
    # Resumo final
    print("\n" + "="*60)
    print("🎯 RESUMO FINAL")
    print("="*60)
    print(f"✅ Modelo treinado com sucesso!")
    print(f"📊 Acurácia alcançada: {accuracy:.1%}")
    print(f"🎯 Problema resolvido: Classificação de status de equipamentos")
    print(f"🤖 Algoritmo utilizado: Random Forest")
    print(f"📈 Features utilizadas: {len(pm.feature_names)} sensores")
    print(f"💾 Gráficos salvos na pasta results/")
    print("\n🏆 Sistema pronto para produção!")

if __name__ == "__main__":
    main()
