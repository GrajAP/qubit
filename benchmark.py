import sys
import time

import numpy as np
from qiskit import QuantumCircuit
from qiskit_aer import AerSimulator


def circuit(n, layers=5):
    rng = np.random.default_rng(0)
    qc = QuantumCircuit(n)
    for _ in range(layers):
        for q in range(n):
            qc.ry(rng.uniform(0, np.pi), q)
        for q in range(n - 1):
            qc.cx(q, q + 1)
    qc.measure_all()
    return qc


sim = AerSimulator()
for n in map(int, sys.argv[1:] or [20, 22, 24, 26]):
    print(f"{n} kubitów: stan zajmuje {2**n * 16 / 2**30:.2f} GB", end=", ", flush=True)
    t = time.time()
    sim.run(circuit(n), shots=100).result()
    print(f"czas {time.time() - t:.1f} s")
