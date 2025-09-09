-- =====================================================
-- SCRIPT DE CRIAÇÃO DO BANCO DE DADOS
-- Sistema de Monitoramento Industrial - Sensores IoT
-- Projeto: Hermes Reply - Fase 5
-- Data: Janeiro 2025
-- =====================================================

-- Criação de Sequências para PKs
CREATE SEQUENCE seq_empresa START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_unidade_fabril START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_setor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tipo_equipamento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_equipamento START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tipo_sensor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sensor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_leitura_sensor START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_parametro_operacional START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_alerta START WITH 1 INCREMENT BY 1;

-- =====================================================
-- TABELA: EMPRESA
-- =====================================================
CREATE TABLE EMPRESA (
    id_empresa NUMBER DEFAULT seq_empresa.NEXTVAL PRIMARY KEY,
    razao_social VARCHAR2(200) NOT NULL,
    cnpj VARCHAR2(18) UNIQUE NOT NULL,
    endereco_completo VARCHAR2(500),
    telefone VARCHAR2(20),
    email_contato VARCHAR2(100),
    data_cadastro DATE DEFAULT SYSDATE,
    status_empresa VARCHAR2(20) DEFAULT 'ATIVA',
    CONSTRAINT chk_status_empresa CHECK (status_empresa IN ('ATIVA', 'INATIVA')),
    CONSTRAINT chk_cnpj_formato CHECK (REGEXP_LIKE(cnpj, '^[0-9]{2}\.[0-9]{3}\.[0-9]{3}/[0-9]{4}-[0-9]{2}$'))
);

-- =====================================================
-- TABELA: UNIDADE_FABRIL
-- =====================================================
CREATE TABLE UNIDADE_FABRIL (
    id_unidade NUMBER DEFAULT seq_unidade_fabril.NEXTVAL PRIMARY KEY,
    id_empresa NUMBER NOT NULL,
    nome_unidade VARCHAR2(100) NOT NULL,
    endereco VARCHAR2(500),
    capacidade_producao NUMBER(10,2),
    unidade_capacidade VARCHAR2(20),
    data_inauguracao DATE,
    status_operacional VARCHAR2(20) DEFAULT 'OPERANDO',
    coordenadas_gps VARCHAR2(50),
    CONSTRAINT fk_unidade_empresa FOREIGN KEY (id_empresa) REFERENCES EMPRESA(id_empresa),
    CONSTRAINT chk_status_unidade CHECK (status_operacional IN ('OPERANDO', 'MANUTENCAO', 'PARADA', 'DESATIVADA'))
);

-- =====================================================
-- TABELA: SETOR
-- =====================================================
CREATE TABLE SETOR (
    id_setor NUMBER DEFAULT seq_setor.NEXTVAL PRIMARY KEY,
    id_unidade NUMBER NOT NULL,
    nome_setor VARCHAR2(100) NOT NULL,
    descricao VARCHAR2(500),
    temperatura_ideal_min NUMBER(5,2),
    temperatura_ideal_max NUMBER(5,2),
    umidade_ideal_min NUMBER(5,2),
    umidade_ideal_max NUMBER(5,2),
    responsavel_tecnico VARCHAR2(100),
    area_m2 NUMBER(8,2),
    CONSTRAINT fk_setor_unidade FOREIGN KEY (id_unidade) REFERENCES UNIDADE_FABRIL(id_unidade),
    CONSTRAINT chk_temp_range CHECK (temperatura_ideal_max > temperatura_ideal_min),
    CONSTRAINT chk_umid_range CHECK (umidade_ideal_max > umidade_ideal_min)
);

-- =====================================================
-- TABELA: TIPO_EQUIPAMENTO
-- =====================================================
CREATE TABLE TIPO_EQUIPAMENTO (
    id_tipo_equipamento NUMBER DEFAULT seq_tipo_equipamento.NEXTVAL PRIMARY KEY,
    nome_tipo VARCHAR2(100) NOT NULL,
    fabricante VARCHAR2(100),
    modelo_padrao VARCHAR2(100),
    potencia_nominal NUMBER(8,2),
    unidade_potencia VARCHAR2(10) DEFAULT 'kW',
    especificacoes_tecnicas CLOB,
    manual_operacao CLOB,
    vida_util_anos NUMBER(3),
    data_cadastro DATE DEFAULT SYSDATE
);

-- =====================================================
-- TABELA: EQUIPAMENTO
-- =====================================================
CREATE TABLE EQUIPAMENTO (
    id_equipamento NUMBER DEFAULT seq_equipamento.NEXTVAL PRIMARY KEY,
    id_setor NUMBER NOT NULL,
    id_tipo_equipamento NUMBER NOT NULL,
    numero_serie VARCHAR2(100) UNIQUE NOT NULL,
    nome_equipamento VARCHAR2(150) NOT NULL,
    data_instalacao DATE NOT NULL,
    data_ultima_manutencao DATE,
    proxima_manutencao DATE,
    status_operacional VARCHAR2(20) DEFAULT 'OPERANDO',
    observacoes CLOB,
    custo_aquisicao NUMBER(12,2),
    CONSTRAINT fk_equip_setor FOREIGN KEY (id_setor) REFERENCES SETOR(id_setor),
    CONSTRAINT fk_equip_tipo FOREIGN KEY (id_tipo_equipamento) REFERENCES TIPO_EQUIPAMENTO(id_tipo_equipamento),
    CONSTRAINT chk_status_equipamento CHECK (status_operacional IN ('OPERANDO', 'MANUTENCAO', 'PARADO', 'DEFEITO', 'DESATIVADO'))
);

-- =====================================================
-- TABELA: TIPO_SENSOR
-- =====================================================
CREATE TABLE TIPO_SENSOR (
    id_tipo_sensor NUMBER DEFAULT seq_tipo_sensor.NEXTVAL PRIMARY KEY,
    nome_tipo VARCHAR2(100) NOT NULL,
    unidade_medida VARCHAR2(20) NOT NULL,
    valor_min_operacao NUMBER(12,4),
    valor_max_operacao NUMBER(12,4),
    precisao_decimal NUMBER(2) DEFAULT 2,
    frequencia_leitura_padrao NUMBER(6) DEFAULT 60, -- em segundos
    descricao_tecnica VARCHAR2(500),
    fabricante_padrao VARCHAR2(100),
    protocolo_comunicacao VARCHAR2(50),
    CONSTRAINT chk_range_operacao CHECK (valor_max_operacao > valor_min_operacao)
);

-- =====================================================
-- TABELA: SENSOR
-- =====================================================
CREATE TABLE SENSOR (
    id_sensor NUMBER DEFAULT seq_sensor.NEXTVAL PRIMARY KEY,
    id_equipamento NUMBER NOT NULL,
    id_tipo_sensor NUMBER NOT NULL,
    numero_serie_sensor VARCHAR2(100) UNIQUE NOT NULL,
    localizacao_especifica VARCHAR2(200),
    data_instalacao DATE NOT NULL,
    data_ultima_calibracao DATE,
    proxima_calibracao DATE,
    status_sensor VARCHAR2(20) DEFAULT 'ATIVO',
    fator_correcao NUMBER(8,4) DEFAULT 1.0000,
    endereco_rede VARCHAR2(50),
    frequencia_leitura NUMBER(6) DEFAULT 60,
    CONSTRAINT fk_sensor_equipamento FOREIGN KEY (id_equipamento) REFERENCES EQUIPAMENTO(id_equipamento),
    CONSTRAINT fk_sensor_tipo FOREIGN KEY (id_tipo_sensor) REFERENCES TIPO_SENSOR(id_tipo_sensor),
    CONSTRAINT chk_status_sensor CHECK (status_sensor IN ('ATIVO', 'INATIVO', 'MANUTENCAO', 'DEFEITO', 'CALIBRACAO'))
);

-- =====================================================
-- TABELA: PARAMETRO_OPERACIONAL
-- =====================================================
CREATE TABLE PARAMETRO_OPERACIONAL (
    id_parametro NUMBER DEFAULT seq_parametro_operacional.NEXTVAL PRIMARY KEY,
    id_sensor NUMBER NOT NULL,
    valor_minimo_normal NUMBER(12,4),
    valor_maximo_normal NUMBER(12,4),
    valor_critico_min NUMBER(12,4),
    valor_critico_max NUMBER(12,4),
    data_vigencia_inicio DATE NOT NULL,
    data_vigencia_fim DATE,
    motivo_alteracao VARCHAR2(500),
    usuario_alteracao VARCHAR2(100),
    CONSTRAINT fk_param_sensor FOREIGN KEY (id_sensor) REFERENCES SENSOR(id_sensor),
    CONSTRAINT chk_param_normal CHECK (valor_maximo_normal > valor_minimo_normal),
    CONSTRAINT chk_param_critico CHECK (valor_critico_max > valor_critico_min)
);

-- =====================================================
-- TABELA: LEITURA_SENSOR (Particionada por data)
-- =====================================================
CREATE TABLE LEITURA_SENSOR (
    id_leitura NUMBER DEFAULT seq_leitura_sensor.NEXTVAL,
    id_sensor NUMBER NOT NULL,
    timestamp_leitura TIMESTAMP(6) NOT NULL,
    valor_medido NUMBER(12,4) NOT NULL,
    valor_corrigido NUMBER(12,4),
    qualidade_sinal NUMBER(3,1) DEFAULT 100.0,
    status_validacao VARCHAR2(20) DEFAULT 'PENDENTE',
    observacoes_automaticas VARCHAR2(500),
    checksum_dados VARCHAR2(32),
    CONSTRAINT pk_leitura PRIMARY KEY (id_leitura, timestamp_leitura),
    CONSTRAINT fk_leitura_sensor FOREIGN KEY (id_sensor) REFERENCES SENSOR(id_sensor),
    CONSTRAINT chk_qualidade_sinal CHECK (qualidade_sinal BETWEEN 0 AND 100),
    CONSTRAINT chk_status_validacao CHECK (status_validacao IN ('PENDENTE', 'VALIDADO', 'REJEITADO', 'CORRIGIDO'))
) PARTITION BY RANGE (timestamp_leitura) (
    PARTITION p_2024_q1 VALUES LESS THAN (DATE '2024-04-01'),
    PARTITION p_2024_q2 VALUES LESS THAN (DATE '2024-07-01'),
    PARTITION p_2024_q3 VALUES LESS THAN (DATE '2024-10-01'),
    PARTITION p_2024_q4 VALUES LESS THAN (DATE '2025-01-01'),
    PARTITION p_future VALUES LESS THAN (MAXVALUE)
);

-- =====================================================
-- TABELA: ALERTA
-- =====================================================
CREATE TABLE ALERTA (
    id_alerta NUMBER DEFAULT seq_alerta.NEXTVAL PRIMARY KEY,
    id_sensor NUMBER NOT NULL,
    id_leitura NUMBER,
    tipo_alerta VARCHAR2(50) NOT NULL,
    nivel_criticidade VARCHAR2(20) NOT NULL,
    timestamp_alerta TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    mensagem_alerta VARCHAR2(1000),
    status_alerta VARCHAR2(20) DEFAULT 'ABERTO',
    usuario_responsavel VARCHAR2(100),
    timestamp_resolucao TIMESTAMP(6),
    acao_corretiva VARCHAR2(1000),
    CONSTRAINT fk_alerta_sensor FOREIGN KEY (id_sensor) REFERENCES SENSOR(id_sensor),
    CONSTRAINT chk_nivel_criticidade CHECK (nivel_criticidade IN ('BAIXO', 'MEDIO', 'ALTO', 'CRITICO')),
    CONSTRAINT chk_status_alerta CHECK (status_alerta IN ('ABERTO', 'EM_ANDAMENTO', 'RESOLVIDO', 'FALSO_POSITIVO'))
);

-- =====================================================
-- ÍNDICES PARA OTIMIZAÇÃO
-- =====================================================

-- Índices para consultas frequentes
CREATE INDEX idx_leitura_sensor_timestamp ON LEITURA_SENSOR(id_sensor, timestamp_leitura);
CREATE INDEX idx_leitura_timestamp ON LEITURA_SENSOR(timestamp_leitura);
CREATE INDEX idx_sensor_equipamento ON SENSOR(id_equipamento);
CREATE INDEX idx_equipamento_setor ON EQUIPAMENTO(id_setor);
CREATE INDEX idx_alerta_timestamp ON ALERTA(timestamp_alerta);
CREATE INDEX idx_alerta_status ON ALERTA(status_alerta);

-- Índices compostos para relatórios
CREATE INDEX idx_sensor_tipo_status ON SENSOR(id_tipo_sensor, status_sensor);
CREATE INDEX idx_equipamento_status ON EQUIPAMENTO(status_operacional, id_setor);

-- =====================================================
-- TRIGGERS PARA AUDITORIA E VALIDAÇÃO
-- =====================================================

-- Trigger para calcular valor corrigido automaticamente
CREATE OR REPLACE TRIGGER trg_calcula_valor_corrigido
    BEFORE INSERT OR UPDATE ON LEITURA_SENSOR
    FOR EACH ROW
DECLARE
    v_fator_correcao NUMBER;
BEGIN
    -- Busca o fator de correção do sensor
    SELECT fator_correcao INTO v_fator_correcao
    FROM SENSOR
    WHERE id_sensor = :NEW.id_sensor;
    
    -- Calcula o valor corrigido
    :NEW.valor_corrigido := :NEW.valor_medido * v_fator_correcao;
    
    -- Gera checksum simples
    :NEW.checksum_dados := SUBSTR(STANDARD_HASH(:NEW.id_sensor || :NEW.timestamp_leitura || :NEW.valor_medido, 'MD5'), 1, 32);
END;
/

-- =====================================================
-- VIEWS PARA CONSULTAS FREQUENTES
-- =====================================================

-- View para dashboard principal
CREATE OR REPLACE VIEW vw_dashboard_sensores AS
SELECT 
    e.nome_equipamento,
    s.nome_setor,
    ts.nome_tipo as tipo_sensor,
    sen.numero_serie_sensor,
    sen.status_sensor,
    ls.timestamp_leitura,
    ls.valor_corrigido,
    ts.unidade_medida,
    CASE 
        WHEN ls.valor_corrigido BETWEEN po.valor_minimo_normal AND po.valor_maximo_normal THEN 'NORMAL'
        WHEN ls.valor_corrigido BETWEEN po.valor_critico_min AND po.valor_critico_max THEN 'ATENCAO'
        ELSE 'CRITICO'
    END as status_operacional
FROM LEITURA_SENSOR ls
JOIN SENSOR sen ON ls.id_sensor = sen.id_sensor
JOIN EQUIPAMENTO e ON sen.id_equipamento = e.id_equipamento
JOIN SETOR s ON e.id_setor = s.id_setor
JOIN TIPO_SENSOR ts ON sen.id_tipo_sensor = ts.id_tipo_sensor
LEFT JOIN PARAMETRO_OPERACIONAL po ON sen.id_sensor = po.id_sensor 
    AND SYSDATE BETWEEN po.data_vigencia_inicio AND NVL(po.data_vigencia_fim, SYSDATE + 1);

-- =====================================================
-- COMENTÁRIOS NAS TABELAS
-- =====================================================

COMMENT ON TABLE EMPRESA IS 'Cadastro das empresas proprietárias das unidades fabris';
COMMENT ON TABLE UNIDADE_FABRIL IS 'Unidades fabris de cada empresa';
COMMENT ON TABLE SETOR IS 'Setores organizacionais dentro de cada unidade fabril';
COMMENT ON TABLE TIPO_EQUIPAMENTO IS 'Catálogo de tipos de equipamentos industriais';
COMMENT ON TABLE EQUIPAMENTO IS 'Equipamentos físicos instalados nos setores';
COMMENT ON TABLE TIPO_SENSOR IS 'Catálogo de tipos de sensores com suas especificações';
COMMENT ON TABLE SENSOR IS 'Sensores físicos instalados nos equipamentos';
COMMENT ON TABLE PARAMETRO_OPERACIONAL IS 'Parâmetros operacionais e limites para cada sensor';
COMMENT ON TABLE LEITURA_SENSOR IS 'Dados coletados pelos sensores (tabela principal de dados)';
COMMENT ON TABLE ALERTA IS 'Alertas gerados automaticamente baseados nos parâmetros operacionais';

-- =====================================================
-- SCRIPT FINALIZADO
-- =====================================================
