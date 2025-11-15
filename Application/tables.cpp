/**
 * @file tables.cpp
 * @brief Implements classes that represent the tables in the database.
*/

#include <iostream>
#include <pqxx/pqxx>
#include <regex>
#include <algorithm>
#include <optional>
#include <iomanip>
#include <sstream>
#include <limits>
#include "tables.hpp"

void getInputString(const std::string &question, std::string &answer) {
    std::cout << question;
    std::getline(std::cin >> std::ws, answer);
    std::transform(answer.begin(), answer.end(), answer.begin(), [](unsigned char c) {return std::toupper(c);});
}

void getInputInt(const std::string &question, std::optional<int> &answer) {
    std::cout << question;

    if (int value; std::cin >> value) {
        answer = value;
    } else {
        answer = std::nullopt;
        std::cin.clear();
        std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    }
}

Paciente::Paciente(pqxx::connection &connection):connection(connection) {}

bool Paciente::inputData() {
    bool valid_input = true;

    getInputString("Digite o CPF (11 dígitos): ", this->cpf);
    getInputString("Digite o CNS (15 dígitos): ", this->cns);
    getInputString("Digite o Nome (Máx. 50 caracteres): ", this->nome);
    getInputString("Digite a Data de Nascimento (DD/MM/YYYY): ", this->data_nasc);
    getInputString("Digite o Sexo (M/F/O): ", this->sexo);
    getInputString("Digite o Celular (DD)NNNNNNNNN: ", this->celular);
    getInputString("Digite o Telefone Fixo (DD)NNNNNNNN: ", this->fixo);
    getInputString("Digite o Email (usuario@email.com): ", this->email);
    getInputString("Digite a Nacionalidade: ", this->nacionalidade);

    // CPF
    if (!std::regex_match(this->cpf, std::regex("^[0-9]{11}$"))) {
        std::cerr << "CPF inválido.\n";
        valid_input = false;
    }

    // CNS
    if (!std::regex_match(this->cns, std::regex("^[0-9]{15}$"))) {
        std::cerr << "CNS inválido.\n";
        valid_input = false;
    }

    // NOME
    if (this->nome.empty() || this->nome.size() > 50) {
        std::cerr << "Nome inválido.\n";
        valid_input = false;
    }

    // DATA
    std::tm date = {};
    std::istringstream string_date(this->data_nasc);
    string_date >> std::get_time(&date, "%d/%m/%Y");
    if (string_date.fail()) {
        std::cerr << "Data inválida.\n";
        valid_input = false;
    }

    // SEXO
    if (this->sexo != "F" && this->sexo != "M" && this->sexo != "O") {
        std::cerr << "Sexo inválido.\n";
        valid_input = false;
    }

    // CELULAR
    if (!this->celular.empty() &&
        !std::regex_match(this->celular, std::regex("^\\(\\d{2}\\)\\d{9}$"))) {
        std::cerr << "Celular inválido.\n";
        valid_input = false;
    }

    // TELEFONE FIXO
    if (!this->fixo.empty() &&
        !std::regex_match(this->fixo, std::regex("^\\(\\d{2}\\)\\d{8}$"))) {
        std::cerr << "Telefone fixo inválido.\n";
        valid_input = false;
    }

    // EMAIL
    if (!this->email.empty() &&
        (!std::regex_match(this->email,
                           std::regex("^[A-Za-z0-9._%+-]+@email\\.com$"))
         || this->email.size() > 40)) {
        std::cerr << "Email inválido. Só são aceitos emails terminados em @email.com.\n";
        valid_input = false;
    }

    // NACIONALIDADE
    if (this->nacionalidade.empty() || this->nacionalidade.size() > 30) {
        std::cerr << "Nacionalidade inválida.\n";
        valid_input = false;
    }

    return valid_input;
}

bool Paciente::insertData() {
    std::string query;
    try {
        pqxx::work transaction(this->connection);

        query =
            "INSERT INTO paciente (cpf, cns, nome, data_nasc, sexo, celular, fixo, email, nacionalidade) VALUES ('" +
            transaction.esc(this->cpf) + "', '" +
            transaction.esc(this->cns) + "', '" +
            transaction.esc(this->nome) + "', " +
            "TO_DATE('" + transaction.esc(this->data_nasc) + "', 'DD/MM/YYYY'), '" +
            transaction.esc(this->sexo) + "', " +
            (this->celular.empty() ? "NULL" : "'" + transaction.esc(this->celular) + "'") + ", " +
            (this->fixo.empty() ? "NULL" : "'" + transaction.esc(this->fixo) + "'") + ", " +
            (this->email.empty() ? "NULL" : "'" + transaction.esc(this->email) + "'") + ", '" +
            transaction.esc(this->nacionalidade) + "');";

        transaction.exec(query);
        transaction.commit();

        std::cout << "Paciente cadastrado com sucesso.\n";
        return true;
    } 
    catch (const std::exception &e) {
        std::cerr << "Erro ao inserir dados do paciente: " << e.what() << "\n";
        return false;
    }
}

Unidade::Unidade(pqxx::connection &connection):connection(connection) {}

bool Unidade::inputData() {
    bool valid_input = true;

    getInputString("Digite o CNES (7 dígitos): ", this->cnes);
    getInputString("Digite o Nome (Máx. 30 caracteres): ", this->nome);
    getInputString("Digite o Tipo (Máx. 20 caracteres) - deixe vazio se não houver: ", this->tipo);
    getInputString("Digite o Telefone (DD)NNNNNNNN: ", this->telefone);
    getInputString("Digite a Cidade: ", this->cidade);
    getInputString("Digite a Rua: ", this->rua);
    getInputInt("Digite o Número: ", this->numero);
    getInputString("Digite o CEP (8 dígitos): ", this->cep);

    // CNES
    if (!std::regex_match(this->cnes, std::regex("^[0-9]{7}$"))) {
        std::cerr << "CNES inválido.\n";
        valid_input = false;
    }

    // NOME
    if (this->nome.empty() || this->nome.size() > 30) {
        std::cerr << "Nome inválido.\n";
        valid_input = false;
    }

    // TIPO
    if (this->tipo.empty() || this->tipo.size() > 20) {
        std::cerr << "Tipo inválido.\n";
        valid_input = false;
    }

    // TELEFONE
    if (!std::regex_match(this->telefone, std::regex("^\\(\\d{2}\\)\\d{8}$"))) {
        std::cerr << "Telefone inválido.\n";
        valid_input = false;
    }

    // CIDADE
    if (this->cidade.empty() || this->cidade.size() > 15) {
        std::cerr << "Cidade inválida.\n";
        valid_input = false;
    }

    // RUA
    if (this->rua.empty() || this->rua.size() > 50) {
        std::cerr << "Rua inválida.\n";
        valid_input = false;
    }

    // NUMERO
    if (this->numero.has_value() && this->numero.value() < 0) {
        std::cerr << "Número inválido.\n";
        valid_input = false;
    }

    // CEP
    if (this->cep.empty() || !std::regex_match(this->cep, std::regex("^[0-9]{8}$"))) {
        std::cerr << "CEP inválido.\n";
        valid_input = false;
    }

    return valid_input;
}

bool Unidade::insertData() {
    std::string query;
    try {
        pqxx::work transaction(this->connection);

        query =
            "INSERT INTO unidade (cnes, nome, tipo, telefone, cidade, rua, numero, cep) VALUES ('" +
            transaction.esc(this->cnes) + "', '" +
            transaction.esc(this->nome) + "', " +
            (this->tipo.empty() ? "NULL" : "'" + transaction.esc(this->tipo) + "'") + ", '" +
            transaction.esc(this->telefone) + "', '" +
            transaction.esc(this->cidade) + "', '" +
            transaction.esc(this->rua) + "', " +
            (this->numero.has_value() ? std::to_string(*this->numero) : "NULL") + ", '" +
            transaction.esc(this->cep) + "');";

        transaction.exec(query);
        transaction.commit();

        std::cout << "Unidade cadastrada com sucesso.\n";
        return true;

    } 
    catch (const std::exception &e) {
        std::cerr << "Erro ao inserir dados da unidade: " << e.what() << "\n";
        return false;
    }
}
