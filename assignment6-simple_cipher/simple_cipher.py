import sys
def simpleCipher(encrypted, k):
    alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    decrypted = ''

    for char in encrypted:
        index = (alphabet.index(char) - k) % 26
        decrypted += alphabet[index]

    return decrypted

# Check if command-line arguments are provided
if len(sys.argv) == 3:
    try:
        encrypted = sys.argv[1].upper()
        if not encrypted.isalpha():
            raise ValueError("The encrypted string must contain only alphabetic characters.")        
        k = int(sys.argv[2])
        if k < 0:
            raise ValueError("The shift value (k) must be a non-negative integer.")
    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)
else:
    # Prompt the user for input
    encrypted = input("Enter the encrypted string (uppercase letters only): ").strip().upper()
    k = int(input("Enter the shift value (integer): "))

# Decrypt and display the result
decrypted_string = simpleCipher(encrypted, k)
print(f"Decrypted string: {decrypted_string}")