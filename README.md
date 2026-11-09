<img src="assets/icon.svg" width="64" height="64" alt="">

# qubit

Środowisko Pythona na spotkanie wprowadzające koła Qubit: IQM + Qiskit, Qiskit Aer i D-Wave Ocean.

## Nix (flake)

```
git clone https://github.com/GrajAP/qubit
cd qubit
nix develop
```

Pierwsze `nix develop` tworzy `.venv` i instaluje pakiety z `environment.yml` (kilka minut). Kolejne uruchomienia trwają parę sekund.

Sprawdzenie:

```
python -c "import iqm.qiskit_iqm, qiskit_aer, dwave.system; print('OK')"
```

Ostrzeżenia `SyntaxWarning` przy pierwszym imporcie są niegroźne.

### VS Code

1. Zamknij wszystkie okna VS Code.
2. W terminalu z `nix develop` wpisz `code .`
3. W notebooku: Select Kernel → Python Environments → `.venv`.

VS Code musi być uruchomiony z `nix develop`, bo pakiety z PyPI (np. `qiskit-aer`) potrzebują ustawionego `LD_LIBRARY_PATH`. Inaczej kernel zgłosi błąd `libstdc++.so.6: cannot open shared object file`.

## Conda (bez Nixa)

```
conda env create -f environment.yml
conda activate qubit
```
