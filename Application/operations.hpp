/**
 * @file operations.hpp
 * @brief Functions for database operations.
*/

#ifndef OPERATIONS_HPP
#define OPERATIONS_HPP

#include <pqxx/pqxx> 

// Admin password constant
inline constexpr std::string_view ADMIN = "admin123";

/**
 * @brief Operation for registering data.
 * @param Pointer for connection to the database.
*/
bool registerOperation(pqxx::connection &connection);

/**
 * @brief Operation for searching data.
 * @param Pointer for connection to the database.
*/
bool searchOperation(pqxx::connection &connection);

#endif // OPERATIONS_HPP