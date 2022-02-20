from enum import Enum
import re


INPUT_BUFFER = []


class OutputMode(Enum):
    TEXT = 0
    NUMBER = 1
    HEXADECIMAL = 2
    ALL = 3
    DEBUG = 3


def ask_input() -> int:
    def escaped(match):
        seq = match.group(1)
        if len(seq) == 3:
            return chr(int(seq))
        if seq == "n": return "\n"
        return seq

    global INPUT_BUFFER
    if len(INPUT_BUFFER) == 0:
        user_input = input(">>> ") or "\x00"  # If the user gives no input, assign "\x00" (NULL) to input
        user_input = re.sub(r"\\(\d{3}|.)", escaped, user_input)
        INPUT_BUFFER = [ord(i) for i in user_input]
    return INPUT_BUFFER.pop(0)


def print_cell(value: int, out_format: OutputMode):
    if out_format == OutputMode.ALL:           print(format(value, "02X"), format(value, ">3"), chr(value))
    elif out_format == OutputMode.TEXT:        print(chr(value), end="")
    elif out_format == OutputMode.NUMBER:      print(format(value, ">3"))
    elif out_format == OutputMode.HEXADECIMAL: print(format(value, "02X"))


def format_memory(memory: bytearray) -> str:
    regex = re.compile(r"((( ..)+?)\2{5,})", flags=re.DOTALL)  # Tries to find repeating patterns
    mem_str = " ".join( format(c, "02x") for c in memory )
    matches = list(map(
        lambda group: f" ...{ group[1] } [x{ len(group[0]) // len(group[1]) }] ...",
        re.findall(regex, mem_str)
    ))
    return re.sub(regex, lambda _: matches.pop(0), mem_str)


def exec_bf_file(path: str, allocated_space: int = 32768, out_format: OutputMode = OutputMode.TEXT):
    mem = bytearray(allocated_space)  # Memory
    pointer = 0  # Memory Pointer

    with open(path, "r") as file:
        bf_program = re.sub(r"[^+\-<>[\].,]", "", file.read())

    # Precompute the jump table for brackets
    jump_table = {}
    opened_brackets = []
    for i, c in enumerate(bf_program):
        if c == "[":
            opened_brackets.append(i)
        elif c == "]":
            paired_bracket = opened_brackets.pop()
            jump_table[paired_bracket] = i
            jump_table[i] = paired_bracket

    program_pointer = 0
    while program_pointer < len(bf_program):
        char = bf_program[program_pointer]  # Current character
        if char == ">": pointer += 1
        elif char == "<": pointer -= 1
        elif char == "+": mem[pointer] = (mem[pointer] + 1) & 0xFF
        elif char == "-": mem[pointer] = (mem[pointer] - 1) & 0xFF
        elif char == ".": print_cell(mem[pointer], out_format)
        elif char == ",": mem[pointer] = ask_input()
        elif char == "[" and mem[pointer] == 0: program_pointer = jump_table[program_pointer]
        elif char == "]" and mem[pointer] != 0: program_pointer = jump_table[program_pointer]

        # Test if out of bounds
        if not 0 <= pointer < allocated_space:
            print(
                f"File {path}, char {program_pointer}\n"
                f"Pointer got out of the allocated range ({pointer})\n"
                f"Memory layout:\n"
                f"{format_memory(mem)}"
            )
            exit(1)

        program_pointer += 1


if __name__ == '__main__':
    exec_bf_file("interpreter.bf", allocated_space=1024, out_format=OutputMode.TEXT)
