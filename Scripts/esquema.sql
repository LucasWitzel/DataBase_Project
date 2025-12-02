-- Creating 'vinculo' table
CREATE TABLE vinculo (
    cpf CHAR(11) NOT NULL,
    vinculo VARCHAR(8) NOT NULL,
    CONSTRAINT pk_vinculo PRIMARY KEY (cpf),
    CONSTRAINT ck_vinculo_cpf CHECK (cpf ~ '^[0-9]{11}$'),
    CONSTRAINT ck_vinculo CHECK (vinculo IN ('PACIENTE', 'MEDICO'))
);

-- Creating 'paciente' table
CREATE TABLE paciente (
    cpf CHAR(11) NOT NULL,
    cns CHAR(15) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    data_nasc DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    celular CHAR(13),
    fixo CHAR(12),
    email VARCHAR(40),
    nacionalidade VARCHAR(30) NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (cpf),
    CONSTRAINT sk_paciente UNIQUE (cns),
    CONSTRAINT fk_paciente FOREIGN KEY (cpf) REFERENCES vinculo(cpf) ON DELETE CASCADE,
    CONSTRAINT ck_paciente_cns CHECK (cns ~ '^[0-9]{15}$'),
    CONSTRAINT ck_paciente_sexo CHECK (sexo IN ('F', 'M', 'O')),
    CONSTRAINT ck_paciente_celular CHECK (
        celular IS NULL
        OR celular ~ E'^\\(\\d{2}\\)\\d{9}$'
    ),
    CONSTRAINT ck_paciente_fixo CHECK (
        fixo IS NULL
        OR fixo ~ E'^\\(\\d{2}\\)\\d{8}$'
    ),
    CONSTRAINT ck_paciente_email CHECK (
        email IS NULL
        OR email ~ E'^[A-Za-z0-9._%+-]+@email\\.com$'
    )
);

-- Creating 'medico' table
CREATE TABLE medico (
    cpf CHAR(11) NOT NULL,
    crm CHAR(15) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    data_nasc DATE NOT NULL,
    sexo CHAR(1) NOT NULL,
    celular CHAR(13),
    fixo CHAR(12),
    email VARCHAR(40),
    nacionalidade VARCHAR(30) NOT NULL,
    idioma1 VARCHAR(20) NOT NULL,
    idioma2 VARCHAR(20),
    idioma3 VARCHAR(20),
    CONSTRAINT pk_medico PRIMARY KEY (cpf),
    CONSTRAINT sk_medico UNIQUE (crm),
    CONSTRAINT fk_medico FOREIGN KEY (cpf) REFERENCES vinculo(cpf) ON DELETE CASCADE,
    CONSTRAINT ck_medico_crm CHECK (crm ~ '^[A-Z0-9]{15}$'),
    CONSTRAINT ck_medico_sexo CHECK (sexo IN ('F', 'M', 'O')),
    CONSTRAINT ck_medico_celular CHECK (
        celular IS NULL
        OR celular ~ E'^\\(\\d{2}\\)\\d{9}$'
    ),
    CONSTRAINT ck_medico_fixo CHECK (
        fixo IS NULL
        OR fixo ~ E'^\\(\\d{2}\\)\\d{8}$'
    ),
    CONSTRAINT ck_medico_email CHECK (
        email IS NULL
        OR email ~ E'^[A-Za-z0-9._%+-]+@email\\.com$'
    )
);

-- Creating 'formacao' table
CREATE TABLE formacao (
    medico CHAR(11) NOT NULL,
    instituicao VARCHAR(60) NOT NULL,
    ano CHAR(4),
    CONSTRAINT pk_formacao PRIMARY KEY (medico, instituicao),
    CONSTRAINT fk_formacao FOREIGN KEY (medico) REFERENCES medico(cpf) ON DELETE CASCADE,
    CONSTRAINT ck_formacao_ano CHECK (ano ~ '^[0-9]{4}$')
);

-- Creating 'especialidade' table
CREATE TABLE especialidade (
    nome VARCHAR(20) NOT NULL,
    preco_base NUMERIC(5, 2) NOT NULL,
    CONSTRAINT pk_especialidade PRIMARY KEY (nome),
    CONSTRAINT ck_especialidade_preco CHECK (preco_base >= 0)
);

-- Creating 'especializacao' table
CREATE TABLE especializacao (
    medico CHAR(11) NOT NULL,
    especialidade VARCHAR(20) NOT NULL,
    CONSTRAINT pk_especializacao PRIMARY KEY (medico, especialidade),
    CONSTRAINT fk_especializacao_medico FOREIGN KEY (medico) REFERENCES medico(cpf) ON DELETE CASCADE,
    CONSTRAINT fk_especializacao_especialidade FOREIGN KEY (especialidade) REFERENCES especialidade(nome) ON DELETE CASCADE
);

-- Creating 'convenio' table
CREATE TABLE convenio (
    cnpj CHAR(14) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    desconto NUMERIC(3, 2) NOT NULL,
    CONSTRAINT pk_convenio PRIMARY KEY (cnpj),
    CONSTRAINT ck_convenio_cnpj CHECK (cnpj ~ '^[0-9]{14}$'),
    CONSTRAINT ck_convenio_desconto CHECK (
        desconto >= 0
        AND desconto <= 1
    )
);

-- Creating 'filiado' table
CREATE TABLE filiado (
    medico CHAR(11) NOT NULL,
    convenio CHAR(14) NOT NULL,
    CONSTRAINT pk_filiado PRIMARY KEY (medico, convenio),
    CONSTRAINT fk_filiado_medico FOREIGN KEY (medico) REFERENCES medico(cpf) ON DELETE CASCADE,
    CONSTRAINT fk_filiado_convenio FOREIGN KEY (convenio) REFERENCES convenio(cnpj) ON DELETE CASCADE
);

-- Creating 'conveniado' table
CREATE TABLE conveniado (
    paciente CHAR(11) NOT NULL,
    convenio CHAR(14) NOT NULL,
    CONSTRAINT pk_conveniado PRIMARY KEY (paciente, convenio),
    CONSTRAINT fk_conveniado_paciente FOREIGN KEY (paciente) REFERENCES paciente(cpf) ON DELETE CASCADE,
    CONSTRAINT fk_conveniado_convenio FOREIGN KEY (convenio) REFERENCES convenio(cnpj) ON DELETE CASCADE
);

-- Creating 'unidade' table
CREATE TABLE unidade (
    cnes CHAR(7) NOT NULL,
    nome VARCHAR(30) NOT NULL,
    tipo VARCHAR(20),
    telefone CHAR(12) NOT NULL,
    cidade CHAR(15) NOT NULL,
    rua CHAR(50) NOT NULL,
    numero INT NOT NULL,
    cep CHAR(8) NOT NULL,
    CONSTRAINT pk_unidade PRIMARY KEY (cnes),
    CONSTRAINT ck_unidade_cnes CHECK (cnes ~ '^[0-9]{7}$'),
    CONSTRAINT ck_unidade_telefone CHECK (
        telefone IS NULL
        OR telefone ~ E'^\\(\\d{2}\\)\\d{8}$'
    ),
    CONSTRAINT ck_unidade_cep CHECK (cep ~ '^[0-9]{8}$')
);

-- Creating 'consulta' table
CREATE TABLE consulta (
    paciente CHAR(11) NOT NULL,
    medico CHAR(11) NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    preco NUMERIC(5, 2) NOT NULL,
    unidade CHAR(7) NOT NULL,
    CONSTRAINT pk_consulta PRIMARY KEY (paciente, medico, data_hora),
    CONSTRAINT fk_consulta_paciente FOREIGN KEY (paciente) REFERENCES paciente(cpf),
    CONSTRAINT fk_consulta_medico FOREIGN KEY (medico) REFERENCES medico(cpf),
    CONSTRAINT fk_consulta_unidade FOREIGN KEY (unidade) REFERENCES unidade(cnes),
    CONSTRAINT ck_consulta_preco CHECK (preco >= 0)
);

-- Creating 'receita' table
CREATE TABLE receita (
    id INT GENERATED ALWAYS AS IDENTITY,
    paciente CHAR(11) NOT NULL,
    medico CHAR(11) NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    CONSTRAINT pk_receita PRIMARY KEY (id),
    CONSTRAINT sk_receita UNIQUE (paciente, medico, data_hora),
    CONSTRAINT fk_receita FOREIGN KEY (paciente, medico, data_hora) REFERENCES consulta(paciente, medico, data_hora) ON DELETE CASCADE
);

-- Creating 'medicamento' table
CREATE TABLE medicamento (
    dcb CHAR(5) NOT NULL,
    nome VARCHAR(30) NOT NULL,
    CONSTRAINT pk_medicamento PRIMARY KEY (dcb),
    CONSTRAINT ck_medicamento_dcb CHECK (dcb ~ '^[A-Z0-9]{5}$')
);

-- Creating 'prescricao' table
CREATE TABLE prescricao (
    receita INT NOT NULL,
    medicamento CHAR(5) NOT NULL,
    forma VARCHAR(15),
    dose VARCHAR(15) NOT NULL,
    frequencia VARCHAR(15) NOT NULL,
    periodo VARCHAR(15),
    generico BOOLEAN NOT NULL,
    CONSTRAINT pk_prescricao PRIMARY KEY (receita, medicamento),
    CONSTRAINT fk_prescricao_receita FOREIGN KEY (receita) REFERENCES receita(id) ON DELETE CASCADE,
    CONSTRAINT fk_prescricao_medicamento FOREIGN KEY (medicamento) REFERENCES medicamento(dcb)
);

-- Creating 'tipo_exame' table
CREATE TABLE tipo_exame (
    nome VARCHAR(20) NOT NULL,
    preco_base NUMERIC(5, 2) NOT NULL,
    CONSTRAINT pk_tipo_exame PRIMARY KEY (nome),
    CONSTRAINT ck_tipo_exame_preco CHECK (preco_base >= 0)
);

-- Creating 'pedido_exame' table
CREATE TABLE pedido_exame (
    id INT GENERATED ALWAYS AS IDENTITY,
    paciente CHAR(11) NOT NULL,
    medico CHAR(11) NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    unidade CHAR(7) NOT NULL,
    CONSTRAINT pk_pedido_exame PRIMARY KEY (id),
    CONSTRAINT sk_pedido_exame UNIQUE (paciente, medico, data_hora, tipo),
    CONSTRAINT fk_pedido_exame_consulta FOREIGN KEY (paciente, medico, data_hora) REFERENCES consulta(paciente, medico, data_hora) ON DELETE CASCADE,
    CONSTRAINT fk_pedido_exame_tipo FOREIGN KEY (tipo) REFERENCES tipo_exame(nome),
    CONSTRAINT fk_pedido_exame_unidade FOREIGN KEY (unidade) REFERENCES unidade(cnes)
);

-- Creating 'exame' table
CREATE TABLE exame (
    pedido INT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    medico CHAR(11) NOT NULL,
    preco NUMERIC(5, 2) NOT NULL,
    CONSTRAINT pk_exame PRIMARY KEY (pedido, data_hora),
    CONSTRAINT fk_exame_pedido FOREIGN KEY (pedido) REFERENCES pedido_exame(id) ON DELETE CASCADE,
    CONSTRAINT fk_exame_medico FOREIGN KEY (medico) REFERENCES medico(cpf),
    CONSTRAINT ck_exame_preco CHECK (preco >= 0)
);

-- Creating 'atendimento' table
CREATE TABLE atendimento (
    medico CHAR(11) NOT NULL,
    unidade CHAR(7) NOT NULL,
    CONSTRAINT pk_atendimento PRIMARY KEY (medico, unidade),
    CONSTRAINT fk_atendimento_medico FOREIGN KEY (medico) REFERENCES medico(cpf) ON DELETE CASCADE,
    CONSTRAINT fk_atendimento_unidade FOREIGN KEY (unidade) REFERENCES unidade(cnes) ON DELETE CASCADE
);

-- Creating 'funcionamento' table
CREATE TABLE funcionamento (
    unidade CHAR(7) NOT NULL,
    dia CHAR(7) NOT NULL,
    horario_abertura TIME NOT NULL,
    horario_fechamento TIME NOT NULL,
    CONSTRAINT pk_funcionamento PRIMARY KEY (unidade, dia),
    CONSTRAINT fk_funcionamento_unidade FOREIGN KEY (unidade) REFERENCES unidade(cnes) ON DELETE CASCADE,
    CONSTRAINT ck_dia CHECK (
        dia IN (
            'Segunda',
            'Terca',
            'Quarta',
            'Quinta',
            'Sexta',
            'Sabado',
            'Domingo'
        )
    ),
    CONSTRAINT ck_horario CHECK (horario_fechamento > horario_abertura)
);
