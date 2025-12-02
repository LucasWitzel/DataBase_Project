/**
 * @file tables.hpp
 * @brief Classes that represent the tables in the database.
*/

#ifndef TABLES_HPP
#define TABLES_HPP

#include <string>
#include <pqxx/pqxx>
#include <optional>

/**
 * @brief Paciente table.
*/
class Paciente {
    private:
        pqxx::connection &connection; // Connection to the database
        std::string cpf; // CPF number
        std::string cns; // CNS number
        std::string nome; // Full name
        std::string data_nasc; // Date of birth
        std::string sexo; // Gender
        std::string celular; // Mobile phone number
        std::string fixo; // Landline phone number
        std::string email; // Email address
        std::string nacionalidade; // Nationality

    public:
        /**
         * @brief Constructor method.
         * @param Pointer for connection to the database.
        */
        Paciente(pqxx::connection &connection);

        /**
         * @brief Collects patient data from user.
        */
        bool inputData();

        /**
         * @brief Inserts patient data into the database.
        */
        bool insertData();
};

/**
 * @brief Unidade table.
*/
class Unidade {
    private:
        pqxx::connection &connection; // Connection to the database
        std::string cnes; // CNES number
        std::string nome; // Unit name
        std::string tipo; // Unit type
        std::string telefone; // Unit phone
        std::string cidade; // City
        std::string rua; // Street
        std::optional<int> numero; // Address number
        std::string cep; // ZIP code

    public:
        /**
         * @brief Constructor method.
         * @param Pointer for connection to the database.
         */
        Unidade(pqxx::connection &connection);

        /**
         * @brief Collects unit data.
         */
        bool inputData();

        /**
         * @brief Inserts unit data into the database.
        */
        bool insertData();
};

#endif // TABLES_HPP