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

## Notebooki

- `1_wyzarzanie_dwave.ipynb`: wyżarzanie kwantowe, QUBO i Ising (D-Wave Ocean).
- `2_kubit_i_bramki_iqm.ipynb`: kubit, bramki i pomiar, obwód na modelu komputera IQM z szumem.
- `shor.ipynb`: algorytm Shora na symulatorze, rozkłada liczby do 1007 (np. 1007 = 19 · 53).
- `test.ipynb`: szybki test, czy środowisko działa.

## Ile kubitów da się zasymulować

Symulator trzyma cały stan kubitów: 2^n liczb zespolonych po 16 B. Każdy kubit więcej to 2 razy więcej RAM-u i czasu.

Pomiar na Ryzen 9 5900X, 32 GB RAM, bez GPU (5 warstw bramek RY + CX, 100 powtórzeń):

| kubity | czas | RAM |
|---|---|---|
| 20 | 0.1 s | 0.1 GB |
| 24 | 1.6 s | 0.3 GB |
| 26 | 6 s | 1.1 GB |
| 28 | 26 s | 4.3 GB |
| 29 | 52 s | 8.5 GB |

Wnioski:

- Komfortowo: 26-28 kubitów na 32 GB RAM. Maksimum: 29.
- 30 kubitów potrzebuje ok. 17 GB, 31 kubitów ok. 34 GB.
- Obwody z małym splątaniem (np. stan GHZ) z `AerSimulator(method="matrix_product_state")` działają nawet dla 1000 kubitów w 0.3 s.
- Algorytm Shora w `shor.ipynb` ma inną granicę: macierz bramki mnożenia rośnie 4 razy z każdym bitem liczby. 1007 zajmuje ok. 35 s, 2021 nie kończy się w 10 minut.

Sprawdź swój komputer (w `nix develop` albo `conda activate qubit`):

```
python benchmark.py 20 24 26 28
```

## Conda (bez Nixa)

```
conda env create -f environment.yml
conda activate qubit
```
