# Data provenance and integrity record

## Official source

- Publisher: Public Health Agency of Canada
- System: Canadian Chronic Disease Surveillance System (CCDSS), 2025 edition
- Data contributed through: April 2025
- Latest fiscal year represented: 2023–2024
- Retrieved: 2026-10-28
- Data tool: https://health-infobase.canada.ca/ccdss/data-tool/

## Raw-file integrity

| Dataset | SHA-256 |
| --- | --- |
| Active prevalence trend | `244512135f86488d1d72a0f7cc7f3b0650ef1c4513546aa604abb01031992176` |
| Life prevalence age distribution | `1e00598a2303d06c53edca9118ea621175ae051c6158c518ca1ae223d399eb5d` |
| Life prevalence, age-standardized | `c89f7dac64a6d97fb3d56ea7335f431fcb6c8a27971b00b7cb8e96f3c72d4ed0` |
| Life prevalence trend | `ea27a2621c024271730d7cbd9db4c96bdb6d431d9c36321f6a970540ffadafeb` |

## Structural checks

| Prepared dataset | Valid rows |
| --- | ---: |
| Life prevalence trend | 798 |
| Active prevalence trend | 798 |
| Life prevalence age distribution | 6,669 |
| Life prevalence, age-standardized | 798 |

The R workflow downloads the source tables again when the raw files are absent. Source footnotes remain in the raw files and are excluded from the analysis-ready tables through explicit row filtering.
