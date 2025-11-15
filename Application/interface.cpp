/**
 * @file interface.cpp
 * @brief Main function for the application.
*/

#include <iostream>
#include <pqxx/pqxx> 
#include <algorithm>
#include <limits>
#include "operations.hpp"

/**
 * @brief Lauches the application interface.
 * @param argc: Argument count from command line.
 * @param argv: Argument vector from command line.
*/
int main(int argc, char *argv[]) {
    if (argc != 4) {
        std::cerr << "Entrada incorreta. Modelo certo: " << argv[0] << " <database> <user> <password>\n";
        return 1;
    }

    std::string data_base = argv[1];
    std::string user = argv[2];
    std::string password = argv[3];

    std::string operation;

    try {
        pqxx::connection connection("dbname=" + data_base + " user=" + user + " password=" + password + " host=localhost");

        if (connection.is_open()) {
            std::cout << "Conexão com o banco de dados estabelecida com sucesso.\n\n" << "Bem vindo ao ConsultApp!\n\n";
            std::cout << "Deseja fazer um Cadastro (C) na base de dados ou realizar uma Busca (B)?: ";

            std::cin >> operation;
            std::transform(operation.begin(), operation.end(), operation.begin(), [](unsigned char c) {return std::toupper(c);});
            
            if (!std::cin) {
                std::cin.clear();
                std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            }

            while (operation != "EXIT") {
                if (operation == "C" || operation == "CADASTRO") {
                    registerOperation(connection);
                }
                else if (operation == "B" || operation == "BUSCA") {
                    searchOperation(connection);
                }
                else {
                    std::cout << "Opção inválida." << std::endl;
                }

                std::cout << "\nDeseja fazer outro Cadastro ou Busca (C/B) ? Digite 'Exit' para sair: ";
                std::cin >> operation;

                if (!std::cin) {
                    std::cin.clear();
                    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
                }

                std::transform(operation.begin(), operation.end(), operation.begin(), [](unsigned char c) {return std::toupper(c);});
            }
            std::cout << "Encerrando o programa. Obrigado por utilizar ConsultApp :)" << std::endl;
        }
        else {
            std::cout << "Não foi possível conectar ao banco de dados." << std::endl;
            return 1;
        }
    }

    catch (const std::exception &e) {
        std::cerr << "Erro: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}