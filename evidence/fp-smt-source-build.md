# Scoped FP SMT exporter source build

Source revision: 52f1b96515da7fbe5059e3251fd603acf56deb2b.
Host: NixOS; snapshot: /tmp/angr-fp-52f1b965.
Command: `nix build --no-link --no-write-lock-file --max-jobs 1 --cores 6 --print-out-paths .#angr`.
Detached unit: angr-fp-build-v3; requested 4 GiB RAM, no swap, six CPUs (10–15).
Exit: 0. Output: /nix/store/82wnvxcwpl6j25l3frqx2al4l3908fyq-python3.12-angr-10.0.1.
Runtime dependency and Python import checks passed. This establishes package buildability; exporter equivalence and CPython lifting checks are separate WRUH checks.
Nix daemon builders are not covered by the submitting client's cgroup accounting; build parallelism was explicitly limited by Nix.
