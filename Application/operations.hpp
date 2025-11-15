/**
 * @file operations.hpp
 * @brief Functions for database operations.
*/

#ifndef OPERATIONS_HPP
#define OPERATIONS_HPP

#include <pqxx/pqxx> 

/**
 * @brief Operation for registering data.
 * @param Pointer for connection to the database.
*/
void registerOperation(pqxx::connection &connection);

/**
 * @brief Operation for searching data.
 * @param Pointer for connection to the database.
*/
void searchOperation(pqxx::connection &connection);

#endif // OPERATIONS_HPP