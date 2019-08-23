from pathlib import Path
from absl import app
from absl import flags


registers = {
    '$zero': '00000',
    '$at':   '00001',
    '$v0':   '00010',
    '$v1':   '00011',
    '$a0':   '00100',
    '$a1':   '00101',
    '$a2':   '00110',
    '$a3':   '00111',
    '$t0':   '01000',
    '$t1':   '01001',
    '$t2':   '01010',
    '$t3':   '01011',
    '$t4':   '01100',
    '$t5':   '01101',
    '$t6':   '01110',
    '$t7':   '01111',
    '$s0':   '10000',
    '$s1':   '10001',
    '$s2':   '10010',
    '$s3':   '10011',
    '$s4':   '10100',
    '$s5':   '10101',
    '$s6':   '10110',
    '$s7':   '10111',
    '$t8':   '11000',
    '$t9':   '11001',
    '$k0':   '11010',
    '$k1':   '11011',
    '$gp':   '11100',
    '$sp':   '11101',
    '$fp':   '11110',
    '$ra':   '11111'
}

opcode = {
    'LW':    '100011',
    'SW':    '101011',

    'ADD':   '100000',
    'ADDU':  '100001',
    'SUB':   '100010',
    'SUBU':  '100011',
    'AND':   '100100',
    'OR':    '100101',
    'XOR':   '100110',
    'NOR':   '100111',
    'SLT':   '101010',
    'SLTU':  '101011',

    'ADDI':  '001000',
    'ADDIU': '001001',
    'SLTI':  '001010',
    'SLTIU': '001011',
    'ANDI':  '001100',
    'ORI':   '001101',
    'XORI':  '001110',
    'LUI':   '001111',

    'SLL':   '000000',
    'SRL':   '000010',
    'SRA':   '000011',
    'SLLV':  '000100',
    'SRLV':  '000110',
    'SRAV':  '000111',

    'MFHI':  '010000',
    'MTHI':  '010001',
    'MFLO':  '010010',
    'MTLO':  '010011',
    'MULT':  '011000',
    'MULTU': '011001',
    'DIV':   '011010',
    'DIVU':  '011011',

    'JR':    '001000',
    'JALR':  '001001',
    'J':     '000010',
    'JAL':   '000011',
    'BEQ':   '000100',
    'BNE':   '000101',
    'BLEZ':  '000110',
    'BGTZ':  '000111'
}


FLAGS = flags.FLAGS
flags.DEFINE_string(
    'input', None, 'Input mips assemply file path.', short_name='i')
flags.DEFINE_string(
    'output', None, 'Output mips bit stream file path.', short_name='o')
flags.DEFINE_bool(
    'split_by_underscore', False,
    'Split bit stream by underscore or not.', short_name='s')


def bits_concat(*args, split_by_underscore=False):
    bits = args[0]
    for b in args[1:]:
        if split_by_underscore:
            bits += '_'
        bits += b
    return bits


def main(argv):
    input = Path(FLAGS.input)
    output = Path(FLAGS.output)
    split_by_underscore = FLAGS.split_by_underscore
    labels = {}
    inss = []

    with input.open('r') as f:
        for i, _line in enumerate(f.readlines()):
            line = _line.rstrip('\n')
            line_split = line.split(':')
            # ラベルを含まない行
            if len(line_split) == 1:
                inss.append(line_split[0].strip())
            # ラベルを含む行
            else:
                label = line_split[0]
                labels[label] = i
                inss.append(line_split[1].strip())
    print('labels:', labels)

    for i, ins in enumerate(inss):
        print('ins:', ins)
        if len(ins) == 0:
            if i < len(inss) - 1:
                if i == 0:
                    with output.open('w') as f:
                        f.write('\n')
                else:
                    with output.open('a') as f:
                        f.write('\n')
            continue

        for j, c in enumerate(ins):
            if c == ' ':
                op, others = ins[:j], ins[j+1:]
                break

        others = [o.strip() for o in others.split(',')]
        if op in ('ADD', 'SUB', 'ADDU', 'SUBU', 'AND', 'OR', 'NOR', 'XOR',
                  'SLT', 'SLTU'):
            r0, r1, r2 = others
            r0 = registers[r0]
            r1 = registers[r1]
            r2 = registers[r2]
            bits = bits_concat('000000', r1, r2, r0, '00000', opcode[op],
                               split_by_underscore=split_by_underscore)
        elif op in ('SLLV', 'SRLV', 'SRAV'):
            r0, r1, r2 = others
            r0 = registers[r0]
            r1 = registers[r1]
            r2 = registers[r2]
            bits = bits_concat('000000', r1, r2, r0, '00000', opcode[op],
                               split_by_underscore=split_by_underscore)
        elif op in ('SLL', 'SRL', 'SRA'):
            r0, r1, shamt = others
            r0 = registers[r0]
            r1 = registers[r1]
            shamt = format(int(shamt), '05b')
            bits = bits_concat('000000', '00000', r1, r0, shamt, opcode[op],
                               split_by_underscore=split_by_underscore)
        elif op in ('ADDI', 'ADDIU', 'ANDI', 'ORI', 'XORI', 'SLTI', 'SLTIU'):
            r0, r1, immd = others
            r0 = registers[r0]
            r1 = registers[r1]
            immd = format(int(immd), '016b')
            bits = bits_concat(opcode[op], r1, r0, immd,
                               split_by_underscore=split_by_underscore)
        elif op in ('LW', 'SW'):
            r0 = others[0]
            offset, r1 = others[1].split('(')
            r1 = r1[:-1]
            r0 = registers[r0]
            r1 = registers[r1]
            offset = format(int(offset), '016b')
            bits = bits_concat(opcode[op], r1, r0, offset,
                               split_by_underscore=split_by_underscore)
        elif op in ('BEQ', 'BNE'):
            r0, r1, label = others
            r0 = registers[r0]
            r1 = registers[r1]
            offset = labels[label]
            offset = format(int(offset) - i - 1, '016b')
            bits = bits_concat(opcode[op], r0, r1, offset,
                               split_by_underscore=split_by_underscore)
        elif op in ('BGEZ', 'BGTZ', 'BLEZ', 'BLTZ'):
            r0, offset = others
            r0 = registers[r0]
            offset = format(int(offset) - i - 1, '016b')
            bits = bits_concat(opcode[op], r0, '00000', offset,
                               split_by_underscore=split_by_underscore)
        elif op in ('J', 'JAL'):
            label = others[0]
            address = labels[label]
            address = format(int(address), '026b')
            bits = bits_concat(opcode[op], address,
                               split_by_underscore=split_by_underscore)
        elif op in ('JR',):
            r0 = others[0]
            r0 = registers[r0]
            bits = bits_concat('000000', r0, '00000', '00000', '00000', opcode[op],
                               split_by_underscore=split_by_underscore)
        elif op in ('JALR',):
            r0, r1 = others
            r0 = registers[r0]
            r1 = registers[r1]
            bits = bits_concat('000000', r0, '00000', r1, '00000', opcode[op],
                               split_by_underscore=split_by_underscore)
        else:
            print(op, others)
            raise NotImplementedError

        if i == 0:
            with output.open('w') as f:
                f.write(bits + '\n')
        else:
            with output.open('a') as f:
                f.write(bits + '\n')


if __name__ == '__main__':
    app.run(main)
