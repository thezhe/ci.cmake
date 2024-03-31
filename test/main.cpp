#include <cstdlib>
#include <iostream>
int main()
{
    std::cout << "CI_BUILD_VERSION=\"" << CI_BUILD_VERSION << "\"\n";
    return EXIT_SUCCESS;
}
