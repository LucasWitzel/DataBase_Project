INSERT INTO vinculo (cpf, vinculo) VALUES
    ('00000000000', 'PACIENTE'),
    ('11111111111', 'MEDICO'),
    ('22222222222', 'PACIENTE'),
    ('33333333333', 'MEDICO'),
    ('44444444444', 'PACIENTE'),
    ('55555555555', 'MEDICO');

INSERT INTO paciente (cpf, cns, nome, data_nasc, sexo, celular, fixo, email, nacionalidade) VALUES
    ('00000000000', '000000000000000', 'Neymar da Silva Santos Júnior', TO_DATE('05/02/1992', 'DD/MM/YYYY'), 'M', '(11)912345678', NULL, 'menino_ney@email.com', 'Brasileiro'),
    ('22222222222', '222222222222222', 'Max Emilian Verstappen', TO_DATE('30/09/1997', 'DD/MM/YYYY'), 'M', NULL, '(31)11223344', 'redbull_boy@email.com', 'Neerlandês'),
    ('44444444444', '444444444444444', 'Mylène Farmer', TO_DATE('12/09/1961', 'DD/MM/YYYY'), 'F', NULL, NULL, 'mylene_desenchantee@email.com', 'Francesa');

INSERT INTO medico (cpf, crm, nome, data_nasc, sexo, celular, fixo, email, nacionalidade, idioma1, idioma2, idioma3) VALUES
    ('11111111111', '111111111111111', 'Dr. Stephen Strange', TO_DATE('01/11/1930', 'DD/MM/YYYY'), 'M', '(21)987654321', '(21)34567890', 'stranger_avenger@email.com', 'Estadunidense', 'Inglês', 'Espanhol', 'Latim'),
    ('33333333333', '333333333333333', 'Dra. Meredith Grey', TO_DATE('27/09/1978', 'DD/MM/YYYY'), 'F', NULL, NULL, 'meredith_anatomy@email.com', 'Estadunidense', 'Inglês', NULL, NULL),
    ('55555555555', '555555555555555', 'Dr. Robert Rey', TO_DATE('01/10/1961', 'DD/MM/YYYY'), 'M', '(61)912345678', NULL, NULL, 'Brasileiro', 'Português', 'Inglês', NULL),
    ('77777777777', '777777777777777', 'Dr. John H. Watson', TO_DATE('07/08/1852', 'DD/MM/YYYY'), 'M', '(44)912345678', NULL, 'john.watson@email.com', 'Britânico', 'Inglês', 'Francês', 'Hindi'),
    ('99999999999', '999999999999999', 'Dr. Tony Chopper', TO_DATE('24/12/1997', 'DD/MM/YYYY'), 'M', NULL, NULL, 'chopper_strawhats@email.com', 'Drumiano', 'Japonês', 'Animalês', NULL);

INSERT INTO formacao (medico, instituicao, ano) VALUES
    ('11111111111', 'Columbia University', '1950'),
    ('33333333333', 'Johns Hopkins University', '2000'),
    ('33333333333', 'Seattle Grace Hospital', '2004'),
    ('55555555555', 'Tufts University School of Medicine', '1990'),
    ('55555555555', 'Harbor-UCLA Medical Center', '1995'),
    ('55555555555', 'University of Tennessee Medical Center', '1997');

INSERT INTO especialidade (nome, preco_base) VALUES
    ('Pediatria', 200.00),
    ('Cardiologia', 500.00),
    ('Dermatologia', 300.00),
    ('Neurologia', 650.00),
    ('Cirurgia', 800.00);

INSERT INTO convenio (cnpj, nome, desconto) VALUES
    ('12121212121212', 'Amil', 0.15),
    ('34343434343434', 'Unimed', 0.20),
    ('45454545454545', 'Bradesco Saúde', 0.70),
    ('89898989898989', 'Sistema Único de Saúde', 1.00);

INSERT INTO filiado (medico, convenio) VALUES
    ('11111111111', '12121212121212'),
    ('11111111111', '34343434343434'),
    ('11111111111', '89898989898989'),
    ('33333333333', '45454545454545');

INSERT INTO conveniado (paciente, convenio) VALUES
    ('00000000000', '12121212121212'),
    ('00000000000', '89898989898989'),
    ('22222222222', '34343434343434');

INSERT INTO consulta (paciente, medico, data_hora, preco, unidade) VALUES
    ('00000000000', '11111111111', TO_TIMESTAMP('10/12/2025 10:00', 'DD/MM/YYYY HH24:MI'), 500.00, '1234567'),
    ('22222222222', '33333333333', TO_TIMESTAMP('11/12/2025 11:00', 'DD/MM/YYYY HH24:MI'), 300.00, '2345678'),
    ('44444444444', '55555555555', TO_TIMESTAMP('12/12/2025 12:00', 'DD/MM/YYYY HH24:MI'), 700.00, '3456789');

INSERT INTO receita (paciente, medico, data_hora) VALUES
    ('00000000000', '11111111111', TO_TIMESTAMP('10/12/2025 10:00', 'DD/MM/YYYY HH24:MI')),
    ('22222222222', '33333333333', TO_TIMESTAMP('11/12/2025 11:00', 'DD/MM/YYYY HH24:MI')),
    ('44444444444', '55555555555', TO_TIMESTAMP('12/12/2025 12:00', 'DD/MM/YYYY HH24:MI'));

INSERT INTO medicamento (dcb, nome) VALUES
    ('03121', 'Dipirona'),
    ('04766', 'Ibuprofeno'),
    ('06827', 'Paracetamol'),
    ('01144', 'Benzetacil'),
    ('00734', 'Amoxicilina'),
    ('02904', 'Diazepam'),
    ('06602', 'Omeprazol'),
    ('05781', 'Metformina');

INSERT INTO prescricao (receita, medicamento, forma, dose, frequencia, periodo, generico) VALUES
    (1, '03121', 'Comprimido', '500mg', '8/8h', '5 dias', TRUE),
    (1, '06827', 'Gotas', '250ml', '4/4h', '1 semana', TRUE),
    (1, '06602', 'Comprimido', '40mg', '12/12h', '3 dias', FALSE),
    (2, '05781', 'Injeção', '100ml', '1x/dia', '2 dia', FALSE),
    (2, '00734', 'Comprimido', '1000mg', '16/16h', '5 dias', TRUE),
    (3, '04766', 'Xarope', '250mg', '6/6h', '10 dias', TRUE),
    (3, '02904', 'Comprimido', '10mg', '12/12h', '7 dias', FALSE),
    (3, '01144', 'Injeção', '200ml', '2x/dia', '4 dia', FALSE);

INSERT INTO pedido_exame (paciente, medico, data_hora, tipo, unidade) VALUES
    ('00000000000', '11111111111', TO_TIMESTAMP('10/12/2025 10:00', 'DD/MM/YYYY HH24:MI'), 'Hemograma', '1234567'),
    ('00000000000', '11111111111', TO_TIMESTAMP('10/12/2025 10:00', 'DD/MM/YYYY HH24:MI'), 'Tomografia', '2345678'),
    ('00000000000', '11111111111', TO_TIMESTAMP('10/12/2025 10:00', 'DD/MM/YYYY HH24:MI'), 'Ultrassonografia', '1234567'),

    ('22222222222', '33333333333', TO_TIMESTAMP('11/12/2025 11:00', 'DD/MM/YYYY HH24:MI'), 'Raio-X', '3456789'),
    ('22222222222', '33333333333', TO_TIMESTAMP('11/12/2025 11:00', 'DD/MM/YYYY HH24:MI'), 'Ressonância', '3456789');

INSERT INTO tipo_exame (nome, preco_base) VALUES
    ('Hemograma', 50.00),
    ('Tomografia', 300.00),
    ('Ultrassonografia', 150.00),
    ('Raio-X', 100.00),
    ('Ressonância', 500.00);

INSERT INTO exame (pedido, data_hora, medico, preco) VALUES
    (1, TO_TIMESTAMP('01/01/2026 19:00', 'DD/MM/YYYY HH24:MI'), '77777777777', 50.00),
    (2, TO_TIMESTAMP('02/01/2026 20:30', 'DD/MM/YYYY HH24:MI'), '77777777777', 100.00),
    (3, TO_TIMESTAMP('03/01/2026 21:45', 'DD/MM/YYYY HH24:MI'), '99999999999', 500.00);

INSERT INTO atendimento (medico, unidade) VALUES
    ('11111111111', '1234567'),
    ('11111111111', '2345678'),
    ('11111111111', '3456789'),
    ('33333333333', '2345678'),
    ('55555555555', '3456789'),
    ('77777777777', '1234567'),
    ('99999999999', '3456789');

INSERT INTO unidade (cnes, nome, tipo, telefone, cidade, rua, numero, cep) VALUES
    ('1234567', 'Asilo Elizabeth Arkham', 'Hospital', '(11)38380129', 'Gotham City', 'Mercey Island', 35, '01001000'),
    ('2345678', 'Hospital Israelita Albert Einstein', 'Hospital', '(11)21511233', 'São Paulo', 'Avenida Albert Einstein', 627, '05652900'),
    ('3456789', 'Clínica Bem Estar', NULL, '(74)228877766', 'Xique-Xique', 'Rua Rosa Baraúna', 123, '47400000');

INSERT INTO funcionamento (unidade, dia, horario_abertura, horario_fechamento) VALUES
    ('1234567', 'Segunda', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS')),
    ('1234567', 'Terça', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS')),
    ('1234567', 'Quarta', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS')),
    ('1234567', 'Quinta', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS')),
    ('1234567', 'Sexta', TO_TIMESTAMP('08:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('18:00:00', 'HH24:MI:SS')),
    ('1234567', 'Sábado', TO_TIMESTAMP('10:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('15:00:00', 'HH24:MI:SS')),
    ('1234567', 'Domingo', TO_TIMESTAMP('10:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('15:00:00', 'HH24:MI:SS')),
    ('2345678', 'Terça', TO_TIMESTAMP('10:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('19:00:00', 'HH24:MI:SS')),
    ('2345678', 'Quarta', TO_TIMESTAMP('10:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('19:00:00', 'HH24:MI:SS')),
    ('2345678', 'Quinta', TO_TIMESTAMP('10:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('19:00:00', 'HH24:MI:SS')),
    ('3456789', 'Sexta', TO_TIMESTAMP('03:00:00', 'HH24:MI:SS'), TO_TIMESTAMP('12:00:00', 'HH24:MI:SS'));
