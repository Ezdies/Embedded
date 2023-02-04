#include <iostream>
#include <cstdint>

int main()
{
    uint16_t DPTR = 540;
    uint8_t DPL = DPTR % 256;
    uint8_t DPH = DPTR / 256;

    std::cout << "DPL: " << (uint16_t)DPL << '\n';
    std::cout << "DPH: " << (uint16_t)DPH << '\n';

    uint16_t cycles = 2;

label1:
    DPL--;
    cycles += 2;
    if (DPL != 0)
    {
        goto label1;
    }
    DPH--;
    cycles += 2;
    if (DPH != 0)
    {
        goto label1;
    }

    std::cout << cycles << '\n';
}