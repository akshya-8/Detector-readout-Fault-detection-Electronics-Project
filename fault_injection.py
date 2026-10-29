def crc8(data):
    crc = 0x00
    for bit in range(15, -1, -1):
        feedback = ((crc >> 7) & 1) ^ ((data >> bit) & 1)
        crc = (crc << 1) & 0xFF
        if feedback:
            crc ^= 0x07
    return crc

data = 0xA53C
reference_crc = crc8(data)
reference_parity = data.bit_count() % 2
total = 0
parity_detected = 0
crc_detected = 0
both_detected = 0
parity_missed_crc_detected = 0
crc_missed = 0

for mask in range(1, 65536):
    received = data ^ mask
    parity_error = (received.bit_count() % 2) != reference_parity
    crc_error = crc8(received) != reference_crc
    total += 1
    parity_detected += parity_error
    crc_detected += crc_error
    both_detected += parity_error and crc_error
    parity_missed_crc_detected += (not parity_error) and crc_error
    crc_missed += not crc_error

print("FAULT-INJECTION RESULTS:")
print(f"Data word:                  0x{data:04X}")
print(f"Total nonzero fault masks:  {total}")
print(f"Parity detected:            {parity_detected}")
print(f"CRC-8 detected:              {crc_detected}")
print(f"Both detected:               {both_detected}")
print(f"Parity missed, CRC detected: {parity_missed_crc_detected}")
print(f"CRC-8 missed:                 {crc_missed}")
print()
print(f"Parity detection rate: {100 * parity_detected / total:.3f}%")
print(f"CRC-8 detection rate:   {100 * crc_detected / total:.3f}%")
print(f"CRC-8 miss rate:        {100 * crc_missed / total:.3f}%")
