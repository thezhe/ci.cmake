#include <cassert>
#include <cstdlib>
#include <iostream>
/*!
 * @brief Print and validate `CI_BUILD_VERSION`
 */
int main()
{
    std::cout << "CI_BUILD_VERSION=\"" << CI_BUILD_VERSION << "\"\n";
    assert(!std::string(CI_BUILD_VERSION).empty());
    return EXIT_SUCCESS;
}
