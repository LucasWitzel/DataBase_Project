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
void registerOperation(pqxx::connection &connection) {
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
    } 
    else if (option == "U" || option == "UNIDADE") {
        Unidade unidade(connection);
        if (unidade.inputData() == true) {
            unidade.insertData();
        }
    } 
    else {
        std::cout << "Opção inválida." << std::endl;
    }
    return;
}

/**
 * @brief Operation for searching data.
 * @param Pointer for connection to the database.
*/
void searchOperation(pqxx::connection &connection) {
    // Placeholder for search functionality
    return;
}