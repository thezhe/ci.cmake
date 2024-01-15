
#include <cstdlib>
#include <iostream>
auto main() -> int
{
    std::cout << "CI_BUILD_VERSION=\"" << CI_BUILD_VERSION << '\"' << '\n';
    return EXIT_SUCCESS;
}
