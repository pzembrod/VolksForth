#!/usr/bin/python3

import os, sys, time

sys.path.append('/usr/share/hatari/hconsole')

import hconsole

args = ['hatari', '--mono', '--cpuclock', '32', # '--conout', '2',
        '--auto', 'C:\\4THCORE.PRG', '--confirm-quit', 'false', '.']

print('will create main')
main = hconsole.Main(args)
code = hconsole.Scancode
print('main created')

while not main.tokens.hatari.is_running():
  print('waiting for hatari to run')
  time.sleep(1)

time.sleep(7)

main.run('text makefile done.txt')
main.run('keypress %s' % code.Return)

while main.tokens.hatari.is_running() and not os.path.exists('DONE.TXT'):
  print('waiting for done.txt')
  time.sleep(1)
print('done.txt found')

main.run("kill")
print('killed')
