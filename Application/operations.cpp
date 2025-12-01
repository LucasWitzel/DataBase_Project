/**
 * @file operations.cpp
 * @brief Implements functions for database operations.
*/

#include <iostream>
#include <pqxx/pqxx>
#include <algorithm>
#include <limits>
#include "operations.hpp"
#include "tables.hpp"

/**
 * @brief Operation for registering data.
 * @param Pointer for connection to the database.
*/
bool registerOperation(pqxx::connection &connection) {
    std::string password;
    std::cout << "Digite a senha de administrador: ";
    std::cin >> password;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

    if (password != ADMIN) {
        std::cout << "Senha incorreta. Acesso negado." << std::endl;
        return false;
    }

    std::string option;
    std::cout << "Deseja fazer o cadastro de um Paciente (P) ou de uma Unidade de Saúde (U)? ";
    
    std::cin >> option;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

    std::transform(option.begin(), option.end(), option.begin(), [](unsigned char c){return std::toupper(c);});

    if (option == "P" || option == "PACIENTE") {
        Paciente paciente(connection);
        if (paciente.inputData() == true) {
            paciente.insertData();
        }
        return true;
    } 
    else if (option == "U" || option == "UNIDADE") {
        Unidade unidade(connection);
        if (unidade.inputData() == true) {
            unidade.insertData();
        }
        return true;
    } 
    else {
        std::cout << "Opção inválida." << std::endl;
        return false;
    }
}

/**
 * @brief Operation for searching data.
 * @param Pointer for connection to the database.
*/
bool searchOperation(pqxx::connection &connection) {
    std::string password;
    std::cout << "Digite a senha de administrador: ";
    std::cin >> password;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

    if (password != ADMIN) {
        std::cout << "Senha incorreta. Acesso negado." << std::endl;
        return false;
    }

    std::string cpf;
    std::cout << "Digite o CPF do paciente para buscar suas consultas: ";
    
    std::cin >> cpf;
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

    std::string query;
    try {
        pqxx::work transaction(connection);

        query = "SELECT nome FROM paciente WHERE cpf = '" + transaction.esc(cpf) + "';";
        pqxx::result pacient_name = transaction.exec(query);

        if (pacient_name.empty()) {
            std::cout << "Nenhum paciente encontrado com o CPF fornecido.\n";
            return false;
        }

        query = "SELECT "
                    "C.data_hora, "
                    "M.nome AS medico, "
                    "U.nome AS unidade, "
                    "C.preco "
                "FROM consulta C "
                    "JOIN medico M  ON C.medico = M.cpf "
                    "JOIN unidade U ON C.unidade = U.cnes "
                "WHERE C.paciente = '" + transaction.esc(cpf) + "' "
                "ORDER BY C.data_hora";

        pqxx::result all_data = transaction.exec(query);

        if (all_data.empty()) {
            std::cout << "Nenhuma consulta encontrada para este paciente.\n";
            return false;
        }

        transaction.commit();
        
        std::cout << "\nConsultas encontradas para " << pacient_name[0]["nome"].c_str() << ":\n";        
        for (const auto& row : all_data) {
            std::cout << "Data/Hora: " << row["data_hora"].c_str() << "\n" 
                << "Médico:    " << row["medico"].c_str() << "\n"
                << "Unidade:   " << row["unidade"].c_str() << "\n"
                << "Preço:     " << row["preco"].c_str() << "\n"
                << "---------------------------------------\n";
        }
        return true;
    } 

    catch (const std::exception &e) {
        std::cerr << "Erro ao buscar dados: " << e.what() << "\n";
        return false;
    }
}