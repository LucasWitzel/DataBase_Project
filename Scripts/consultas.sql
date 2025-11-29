-- Valor médio e quantidade de consultas realizadas por cada médico, mostrando apenas médicos que já atenderam pelo menos 1 paciente.
SELECT m.cpf,
       m.nome,
       COUNT(c.*) AS qtd_consultas,
       AVG(c.preco) AS media_preco
FROM medico m
JOIN consulta c ON c.medico = m.cpf
GROUP BY m.cpf, m.nome
ORDER BY qtd_consultas DESC;



--Listar todos os médicos e, se existirem, as instituições onde se formaram. Médicos sem formação cadastrada também aparecem.
SELECT m.cpf, m.nome AS medico, f.instituicao, f.ano
FROM medico m
LEFT JOIN formacao f ON f.medico = m.cpf
ORDER BY m.nome;


-- Listar pacientes cuja última consulta foi mais cara do que a média de todas as consultas daquele mesmo médico.
SELECT p.cpf, p.nome
FROM paciente p
WHERE EXISTS (
    SELECT 1
    FROM consulta c1
    WHERE c1.paciente = p.cpf
      AND c1.data_hora = (
            SELECT MAX(c2.data_hora)
            FROM consulta c2
            WHERE c2.paciente = p.cpf
      )
      AND c1.preco > (
            SELECT AVG(c3.preco)
            FROM consulta c3
            WHERE c3.medico = c1.medico
              AND c3.data_hora < c1.data_hora
      )
);



-- Listar médicos que NÃO são filiados a nenhum convênio que ofereça desconto acima de 0.5.
SELECT m.cpf, m.nome
FROM medico m
WHERE m.cpf NOT IN (
    SELECT f.medico
    FROM filiado f
    JOIN convenio c ON c.cnpj = f.convenio
    WHERE c.desconto > 0.5
);


-- Médicos que atendem em todas as unidades cadastradas (divisão relacional aplicada a todas as unidade).
SELECT m.cpf, m.nome
FROM medico m
WHERE NOT EXISTS (
    SELECT u.cnes
    FROM unidade u
    WHERE NOT EXISTS (
        SELECT 1
        FROM atendimento a
        WHERE a.medico = m.cpf
          AND a.unidade = u.cnes
    )
);


