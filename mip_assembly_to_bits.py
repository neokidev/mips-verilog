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
    'ADD':   '100000',
    'ADDI':  '001000',
    'LW':    '100011',
    'SW':    '101011'
}


FLAGS = flags.FLAGS

flags.DEFINE_string(
    'input', None, 'Input mips assemply file path.', short_name='i')

flags.DEFINE_string(
    'output', None, 'Output mips bit stream file path.', short_name='o')

flags.DEFINE_bool(
    'split_by_underscore', False, 'Split bit stream by underscore or not.', short_name='s')


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
            if len(line_split) == 1:
                inss.append(line_split[0])
            else:
                label = line_split[0]
                labels[label] = i
                inss.append(line_split[1])

    for i, ins in enumerate(inss):
        for j, c in enumerate(ins):
            if c == ' ':
                op, others = ins[:j], ins[j+1:]
                break

        others = [o.strip() for o in others.split(',')]
        if op in ('ADD',):
            r0, r1, r2 = others
            r0 = registers[r0]
            r1 = registers[r1]
            r2 = registers[r2]
            bits = bits_concat('000000', r1, r2, r0, '00000', opcode[op],
                               split_by_underscore=split_by_underscore)
        elif op in ('ADDI',):
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

        if i == 0:
            with output.open('w') as f:
                f.write(bits + '\n')
        else:
            with output.open('a') as f:
                f.write(bits + '\n')


if __name__ == '__main__':
    app.run(main)
