Simple TODO app written in odin using clay (c layout library)

# Dependencies (Dev)
- clay.lib (library binary built from the c library source)

# Run (Dev)
Assuming clay.lib is in the same working directory as the app:
```console
odin run -extra-linker-flags:"clay.lib"
```
