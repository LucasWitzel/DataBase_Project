-- Consulta 1
-- Seleciona para cada especialidade a quantidade de médicos, consultas e receita total.
SELECT E.nome AS Especialidade,
  COUNT(DISTINCT R.medico) AS Qtd_medicos,
  COUNT(C.paciente) AS Qtd_consultas,
  SUM(C.preco) AS Receita_total
FROM especialidade E
  JOIN residencia R ON E.nome = R.especializacao
  JOIN medico M ON R.medico = M.cpf
  JOIN consulta C ON M.cpf = C.medico
GROUP BY E.nome
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
SELECT P.cpf,
  P.nome
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
SELECT DISTINCT p.nome,
  pe.tipo
FROM paciente p
  JOIN pedido_exame pe ON pe.paciente = p.cpf
WHERE pe.tipo IN (
    SELECT ped.tipo
    FROM pedido_exame ped
      JOIN exame e ON e.pedido = ped.id
    GROUP BY ped.tipo
    HAVING AVG(e.preco) > (
        SELECT AVG(e2.preco)
        FROM exame e2
      )
  );

-- Consulta 5
-- Seleciona medicos que atendem em todas as unidades onde existam pacientes conveniados 
-- aos mesmos convênios aos quais ele eh filiado.
SELECT m.cpf,
  m.nome
FROM medico m
WHERE NOT EXISTS (
    SELECT DISTINCT C_Alvo.unidade
    FROM consulta C_Alvo
      JOIN conveniado CV ON C_Alvo.paciente = CV.paciente
      JOIN filiado F ON F.convenio = CV.convenio
    WHERE F.medico = m.cpf
      AND NOT EXISTS (
        SELECT 1
        FROM atendimento A
        WHERE A.medico = m.cpf
          AND A.unidade = C_Alvo.unidade
      )
  );
