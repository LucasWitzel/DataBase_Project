-- Consulta 1
-- Seleciona para cada especialidade a quantidade de médicos, consultas e receita total.
SELECT especialidade.nome AS Especialidade,
  COUNT(DISTINCT especializacao.medico) AS Qtd_medicos,
  COUNT(C.paciente) AS Qtd_consultas,
  SUM(C.preco) AS Receita_total
FROM especialidade
  JOIN especializacao ON especialidade.nome = especializacao.especialidade
  JOIN medico M ON especializacao.medico = M.cpf
  JOIN consulta C ON M.cpf = C.medico
GROUP BY especialidade.nome
HAVING COUNT (C.paciente) > 0
ORDER BY Receita_total;

-- Consulta 2
-- Seleciona para cada unidade o numero de consultas e exames realizados.
SELECT U.nome AS Unidade,
  C.qtd_consultas AS Consultas_Realizadas,
  E.qtd_exames_realizados AS Exames_Realizados
FROM unidade U
  LEFT JOIN (
    SELECT unidade,
      COUNT(*) AS qtd_consultas
    FROM consulta
    GROUP BY unidade
  ) AS C ON U.cnes = C.unidade
  LEFT JOIN (
    SELECT PE.unidade,
      COUNT(EX.pedido) AS qtd_exames_realizados
    FROM pedido_exame PE
      JOIN exame EX ON PE.id = EX.pedido
    GROUP BY PE.unidade
  ) AS E ON U.cnes = E.unidade
ORDER BY U.nome;

-- Consulta 3
-- Seleciona pacientes cuja última consulta foi com um médico que já havia os atendido antes.
SELECT P.cpf, P.nome
FROM paciente P
WHERE EXISTS (
    SELECT 1
    FROM consulta C1
    WHERE P.cpf = C1.paciente
      AND C1.data_hora = (
        SELECT MAX(C2.data_hora)
        FROM consulta C2
        WHERE P.cpf = C2.paciente
      )
      AND EXISTS (
        SELECT 1
        FROM consulta C3
        WHERE P.cpf = C3.paciente
          AND C1.medico = C3.medico
          AND C1.data_hora > C3.data_hora
      )
  );

-- Consulta 4
-- Seleciona pacientes que fizeram pedidos de exame cuja média de preço (dos exames realizados) 
-- eh maior que a média geral de preço de todos os exames.
SELECT DISTINCT P.nome, PE1.tipo
FROM paciente P
  JOIN pedido_exame PE1 ON PE1.paciente = P.cpf
WHERE PE1.tipo IN (
    SELECT PE2.tipo
    FROM pedido_exame PE2
      JOIN exame EX1 ON EX1.pedido = PE2.id
    GROUP BY PE2.tipo
    HAVING AVG(EX1.preco) > (
        SELECT AVG(EX2.preco)
        FROM exame EX2
      )
  );

-- Consulta 5
-- Seleciona medicos que atendem em todas as unidades onde existam pacientes conveniados 
-- aos mesmos convênios aos quais ele eh filiado.
SELECT M.crm, M.nome
FROM medico M
WHERE NOT EXISTS (
    SELECT DISTINCT C.unidade
    FROM consulta C
      JOIN conveniado CV ON C.paciente = CV.paciente
      JOIN filiado F ON F.convenio = CV.convenio
    WHERE F.medico = M.cpf
      AND NOT EXISTS (
        SELECT 1
        FROM atendimento A
        WHERE A.medico = M.cpf
          AND A.unidade = C.unidade
      )
  );
