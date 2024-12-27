
# Hatari setup:
# sudo apt install hatari
# sudo cp emutos-512k-1.3/etos512us.img /usr/share/hatari/tos.img

run-4thcore:
	hatari --mono --sound off  --cpuclock 32 --auto 4thcore.prg \
	--confirm-quit false .

run-hconsole:
	./emulator/run-in-hatari.py 4thcore.prg ".( hello world)" "1 2 + ."
