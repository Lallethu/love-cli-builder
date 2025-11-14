# love-cli-builder

A lightweight **CLI tool** to package and export [LÖVE2D](https://love2d.org/) projects directly from the command line.
Designed for **Windows**, using native PowerShell zipping and standard Lua I/O utilities.

---

## Features

- Package a full LÖVE2D project into a single `.exe` file.
- Pure Lua implementation (no external dependencies).
- Safe directory scanning (memory-friendly).
- Works via **Command Prompt** or **PowerShell**.
- Simple CLI interface for automation or integration in build pipelines.
- Automatic and safe set path handling (if needed).

---

## Requirements

- [Lua 5.4+](https://www.lua.org/download.html) installed and accessible via PATH.
- Windows OS (uses `dir` and PowerShell for zipping).

---

## Installation

1. Clone or download the repository:

   ```bash
   git clone https://github.com/Lallethu/love-cli-builder.git
   ```

2. Add the `.cmd` file to your system PATH (optional but recommended):

   - open System Properties > Advanced > Environment Variables.
   - Edit the `Path` variable and add the directory where `love-cli-builder.cmd` is located.
   - e.g., `C:\path\to\love-cli-builder\`

   or run the `set-path.bat` script included in the repo.

3. Test the command:

   ```cmd
   love-cli-builder
   ```

You should see the usage message:

```txt
Usage: love-cli-builder <project_dir> <output_executable_name> <flag>
[...]
```

Otherwise, run it directly via Lua:

```cmd
cd to\love-cli-builder
lua ./main.lua "<project_path>" "<output_executable_name>" "<flag>"
```

---

## Usage

Basic syntax:

```cmd
love-cli-builder [help|h]
```

or:

```cmd
love-cli-builder "<project_path>" "<output_executable_name>" "<flag>"
```

### Parameters

- `<project_path>`: Full path to the LÖVE2D project directory.
- `<output_executable_name>`: Desired output file name (e.g. `pong`).
- `<flag>`: `1` to remove `t.console = true` from `conf.lua`, `0` to keep it.

Example:

```cmd
love-cli-builder "C:\Users\Me\Documents\LOVE2D\pong-clone\" "pong" "1"
```

This will create `pong.exe` in the output directory.

### Warnings

Don't forget when sharing or deploying your packaged game:

- Ensure the `.exe` is in the `./dlls/` folder alongside the LÖVE2D DLLs.
- Optional: you could duplicate the `./dlls/` folder and zip/compress it to ease distribution.

---

## Development Notes

- Uses `io.popen` to iterate over files safely.
- Avoids memory leaks by closing handles properly.
- Compatible with both `cmd.exe` and `powershell.exe` (quotes differ slightly).
- Intended for **packaging**, not code compilation.

---

## Future Possible Improvements

- Optional `.love` file export.
- Custom ignore patterns (e.g. `.git`, `.vscode`).
- Build hooks (pre/post packaging).
- Cross-platform support (macOS/Linux).

---

## Contributing

Contributions, issues, and pull requests are welcome.
Follow a clean and modular Lua coding style, and document new features in the README.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Credits and References

See [`credits.md`](credits.md) for detailed references and helpful links.
