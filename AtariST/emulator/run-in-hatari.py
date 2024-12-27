#!/usr/bin/python3

import os, sys, time

sys.path.append('/usr/share/hatari/hconsole')

import hconsole

# emulatordir="$(realpath --relative-to="$PWD" "$(dirname "${BASH_SOURCE[0]}")")"
# basedir="$(realpath --relative-to="$PWD" "${emulatordir}/..")"
# cpmfilesdir="${basedir}/cpmfiles"

cwd = os.path.abspath(os.path.curdir)
emulatordir = os.path.relpath(os.path.dirname(sys.argv[0]), start=cwd)
basedir = os.path.normpath(os.path.join(emulatordir, '..'))
print('cwd = %s' % cwd)
print('emulatordir = %s' % emulatordir)
print('basedir = %s' % basedir)

# forth="$1"
# forthcmd="$2"

forth = sys.argv[1] if len(sys.argv) > 1 else '4thcore.prg'

hatari_args = [
    'hatari', '--mono', '--sound', 'off', '--cpuclock', '32',
    # '--conout', '2',
    '--auto', forth, '--confirm-quit', 'false', '.']

print('will create main')
main = hconsole.Main(hatari_args)
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
