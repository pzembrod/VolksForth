#!/usr/bin/python3

import sys

sys.path.append('/usr/share/hatari/hconsole')

import hconsole

args = ['--mono', '--cpuclock', '32', '--auto', 'C:\\4THCORE.PRG',
        '--confirm-quit', 'false', '.']

print('will create main')
main = hconsole.Main(args)
code = hconsole.Scancode
print('main created')

main.run('sleep 10')
print('3 slept')
main.run("kill")
print('killed')
