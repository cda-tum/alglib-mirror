# ALGLIB Mirror

[![Releases](https://img.shields.io/github/v/release/cda-tum/alglib-mirror?label=Latest%20Version&style=flat-square)](https://github.com/cda-tum/alglib-mirror/releases)
[![License](https://img.shields.io/github/license/cda-tum/alglib-mirror?label=License&style=flat-square)](https://github.com/cda-tum/alglib-mirror/blob/main/LICENSE.md)


> A reliable mirror of [ALGLIB](http://www.alglib.net/) library tarballs hosted on GitHub for CI/CD reliability.

## 🎯 Purpose

The official ALGLIB download site frequently experiences:

- ⏱️ **Timeouts** in CI environments (especially GitHub Actions)
- 🐌 **Slow download speeds** due to server limitations
- 🔓 **HTTP-only** downloads (no HTTPS available)
- 🌐 **Geographic availability** issues

This mirror provides:

- ✅ **Fast, reliable downloads** via GitHub's global CDN
- ✅ **HTTPS support** for secure downloads
- ✅ **High availability** (GitHub's 99.9%+ uptime)
- ✅ **Multiple versions** readily available
- ✅ **No authentication required** for public access

## 📦 Available Versions

This mirror hosts **C++ GPL editions** of ALGLIB from version 3.9.0 through 4.07.0.

See [Releases](https://github.com/cda-tum/alglib-mirror/releases) for the complete list of available versions.

| Version Range  | Format         | License |
|----------------|----------------|---------|
| 3.9.0 - 4.07.0 | `.cpp.gpl.tgz` | GPL 3.0 |

## 🚀 Quick Start

### Download Latest Version

```bash
# Using wget
wget https://github.com/cda-tum/alglib-mirror/releases/download/v3.14.0/alglib-3.14.0.cpp.gpl.tgz

# Using curl
curl -L -O https://github.com/cda-tum/alglib-mirror/releases/download/v3.14.0/alglib-3.14.0.cpp.gpl.tgz
```

### Use in CMake Projects

```cmake
set(ALGLIB_VERSION "3.14.0")
set(ALGLIB_FILE "alglib-${ALGLIB_VERSION}.cpp.gpl.tgz")

# Try GitHub mirror first, fallback to official site
set(ALGLIB_URLS
        "https://github.com/cda-tum/alglib-mirror/releases/download/v${ALGLIB_VERSION}/${ALGLIB_FILE}"
        "http://www.alglib.net/translator/re/${ALGLIB_FILE}"
)

include(FetchContent)
FetchContent_Declare(
        alglib
        URL ${ALGLIB_URLS}
)
FetchContent_MakeAvailable(alglib)
```

### Use in CI/CD Pipelines

#### GitHub Actions

```yaml
- name: Download ALGLIB
  run: |
    wget https://github.com/cda-tum/alglib-mirror/releases/download/v3.14.0/alglib-3.14.0.cpp.gpl.tgz
    tar -xzf alglib-3.14.0.cpp.gpl.tgz
```

#### GitLab CI

```yaml
before_script:
  - wget https://github.com/cda-tum/alglib-mirror/releases/download/v3.14.0/alglib-3.14.0.cpp.gpl.tgz
  - tar -xzf alglib-3.14.0.cpp.gpl.tgz
```

## 📚 Documentation

### URL Pattern

All releases follow this consistent URL pattern:

```
https://github.com/cda-tum/alglib-mirror/releases/download/v{VERSION}/alglib-{VERSION}.cpp.gpl.tgz
```

**Examples:**

- v3.14.0: `https://github.com/cda-tum/alglib-mirror/releases/download/v3.14.0/alglib-3.14.0.cpp.gpl.tgz`
- v4.00.0: `https://github.com/cda-tum/alglib-mirror/releases/download/v4.00.0/alglib-4.00.0.cpp.gpl.tgz`
- v4.07.0: `https://github.com/cda-tum/alglib-mirror/releases/download/v4.07.0/alglib-4.07.0.cpp.gpl.tgz`

### Verifying Downloads

Each release page includes:

- ✅ File size verification
- ✅ Link to original source

```bash
# Download and verify
wget https://github.com/cda-tum/alglib-mirror/releases/download/v3.14.0/alglib-3.14.0.cpp.gpl.tgz

# Check file size (should be ~2.4 MB)
ls -lh alglib-3.14.0.cpp.gpl.tgz

# Extract
tar -xzf alglib-3.14.0.cpp.gpl.tgz
```

## 🔄 Version History

| Version | Release Date | Size   | Notes         |
|---------|--------------|--------|---------------|
| 4.07.0  | Dec 2025     | 4.0 MB | Latest        |
| 4.06.0  | Oct 2025     | 4.0 MB |               |
| 4.05.0  | Jun 2025     | 3.8 MB |               |
| 4.04.0  | Dec 2024     | 3.7 MB |               |
| 4.03.0  | Sep 2024     | 3.6 MB |               |
| 4.02.0  | May 2024     | 3.6 MB |               |
| 4.01.0  | Dec 2023     | 3.5 MB |               |
| 4.00.0  | May 2023     | 3.3 MB | Major version |
| 3.20.0  | Dec 2022     | 3.2 MB |               |
| 3.19.0  | Jun 2022     | 3.1 MB |               |
| 3.18.0  | Oct 2021     | 3.0 MB |               |
| 3.17.0  | Dec 2020     | 2.9 MB |               |
| 3.16.0  | Dec 2019     | 2.8 MB |               |
| 3.15.0  | Feb 2019     | 2.7 MB |               |
| 3.14.0  | Jun 2018     | 2.4 MB | Widely used   |
| 3.13.0  | Dec 2017     | 2.3 MB |               |
| 3.12.0  | Aug 2017     | 2.2 MB |               |
| 3.11.0  | May 2017     | 2.2 MB |               |
| 3.10.0  | Aug 2015     | 1.9 MB |               |
| 3.9.0   | Dec 2014     | 1.8 MB |               |

See [Releases](https://github.com/cda-tum/alglib-mirror/releases) for the complete version log.

## 📖 About ALGLIB

**ALGLIB** is a cross-platform numerical analysis and data processing library. It supports several programming
languages (C++, C#, Python, etc.) and provides:

- Linear algebra (direct algorithms, EVD, SVD)
- Solvers (linear, quadratic, nonlinear)
- Interpolation
- Optimization
- Fast Fourier transforms
- Numerical integration
- Linear and nonlinear least-squares fitting
- Ordinary differential equations
- Special functions
- Statistics (descriptive, hypothesis testing)
- Data analysis (classification, regression)

**Official Website:** http://www.alglib.net/  
**License:** GPL 3.0 (for GPL editions)  
**Languages:** C++, C#, Delphi, Python, Java, and more

## 📄 License

### This Mirror Repository

This repository only mirrors distribution files and does not modify ALGLIB. All mirrored files retain their original
licenses.

The repository content is released under the MIT license.

### ALGLIB Library License

The mirrored ALGLIB files are distributed under the **GNU General Public License** (GPL 2+).

All rights to ALGLIB belong to the original authors. See http://www.alglib.net/ for more information.

## 🤝 Contributing

### Request a New Version

If you need a specific ALGLIB version that's not yet mirrored, open
an [issue](https://github.com/cda-tum/alglib-mirror/issues) with the version number.

### Report Issues

Found a problem with a download or release? Please [open an issue](https://github.com/cda-tum/alglib-mirror/issues) and
include:

- Version number
- Download URL used
- Error message or unexpected behavior
- Your environment (OS, download tool, etc.)

## ⚠️ Disclaimer

This is an **unofficial mirror** provided as a community service. We are not affiliated with the ALGLIB project or its
authors.

For the official source and latest versions, please visit: http://www.alglib.net/

Downloads from this mirror are provided "as-is" without warranty of any kind. Always verify downloads against official
sources when security is critical.

---

This project has been supported by the Bavarian State Ministry for Science and Arts through the
Distinguished Professorship Program.

<p align="center">
<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/munich-quantum-toolkit/.github/refs/heads/main/docs/_static/logo-tum-dark.svg" width="28%">
<img src="https://raw.githubusercontent.com/munich-quantum-toolkit/.github/refs/heads/main/docs/_static/logo-tum-light.svg" width="28%" alt="TUM Logo">
</picture>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <!-- Non-breaking spaces for spacing -->
<picture>
<img src="https://raw.githubusercontent.com/munich-quantum-toolkit/.github/refs/heads/main/docs/_static/logo-bavaria.svg" width="16%" alt="Coat of Arms of Bavaria">
</picture>
</p>
